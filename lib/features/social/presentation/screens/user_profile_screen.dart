import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uit_buddy_mobile/app/di/app_dependencies.dart';
import 'package:uit_buddy_mobile/core/theme/app_color.dart';
import 'package:uit_buddy_mobile/core/theme/app_text_style.dart';
import 'package:uit_buddy_mobile/features/session/presentation/bloc/session_bloc.dart';
import 'package:uit_buddy_mobile/features/social/domain/entities/conversation_entity.dart';
import 'package:uit_buddy_mobile/features/social/domain/entities/other_people_entity.dart';
import 'package:uit_buddy_mobile/features/social/domain/entities/post_entity.dart';
import 'package:uit_buddy_mobile/features/social/domain/entities/search_user_entity.dart';
import 'package:uit_buddy_mobile/features/social/presentation/bloc/user_profile/user_profile_bloc.dart';
import 'package:uit_buddy_mobile/features/social/presentation/bloc/user_profile/user_profile_event.dart';
import 'package:uit_buddy_mobile/features/social/presentation/bloc/user_profile/user_profile_state.dart';
import 'package:uit_buddy_mobile/features/social/presentation/screens/edit_post_screen.dart';
import 'package:uit_buddy_mobile/features/social/presentation/screens/post_detail_screen.dart';
import 'package:uit_buddy_mobile/features/social/presentation/widgets/post_card.dart';
import 'package:uit_buddy_mobile/features/social/presentation/widgets/post_card_skeleton.dart';

class UserProfileScreen extends StatelessWidget {
  const UserProfileScreen({super.key, required this.mssv});

  final String mssv;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          serviceLocator<UserProfileBloc>()
            ..add(UserProfileStarted(mssv: mssv)),
      child: const _UserProfileView(),
    );
  }
}

class _UserProfileView extends StatefulWidget {
  const _UserProfileView();

  @override
  State<_UserProfileView> createState() => _UserProfileViewState();
}

class _UserProfileViewState extends State<_UserProfileView> {
  late final ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController()..addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_onScroll)
      ..dispose();
    super.dispose();
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;
    final position = _scrollController.position;
    if (position.pixels >= position.maxScrollExtent - 200) {
      context.read<UserProfileBloc>().add(const UserProfilePostsLoadMore());
    }
  }

  Future<void> _navigateToEdit(BuildContext context, PostEntity post) async {
    final bloc = context.read<UserProfileBloc>();
    final updated = await Navigator.of(context).push<PostEntity>(
      MaterialPageRoute(builder: (_) => EditPostScreen(post: post)),
    );
    if (updated != null && context.mounted) {
      bloc.add(UserProfilePostUpdated(updatedPost: updated));
    }
  }

  Future<void> _openPostDetail(BuildContext context, PostEntity post) async {
    await Navigator.of(context).push<void>(
      MaterialPageRoute(
        builder: (_) => PostDetailScreen(postId: post.id, initialPost: post),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.pureWhite,
      appBar: AppBar(
        backgroundColor: AppColor.pureWhite,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            size: 18,
            color: AppColor.primaryText,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(1),
          child: Divider(height: 1, color: AppColor.dividerGrey),
        ),
      ),
      body: BlocConsumer<UserProfileBloc, UserProfileState>(
        listenWhen: (previous, current) =>
            previous.actionErrorMessage != current.actionErrorMessage ||
            previous.actionSuccessMessage != current.actionSuccessMessage,
        listener: (context, state) {
          final messenger = ScaffoldMessenger.of(context);

          if (state.actionErrorMessage != null) {
            messenger
              ..hideCurrentSnackBar()
              ..showSnackBar(
                SnackBar(
                  content: Text(state.actionErrorMessage!),
                  backgroundColor: AppColor.alertRed,
                  behavior: SnackBarBehavior.floating,
                ),
              );
            context.read<UserProfileBloc>().add(
              const UserProfileFeedbackCleared(),
            );
          } else if (state.actionSuccessMessage != null) {
            messenger
              ..hideCurrentSnackBar()
              ..showSnackBar(
                SnackBar(
                  content: Text(state.actionSuccessMessage!),
                  backgroundColor: AppColor.successGreen,
                  behavior: SnackBarBehavior.floating,
                ),
              );
            context.read<UserProfileBloc>().add(
              const UserProfileFeedbackCleared(),
            );
          }
        },
        builder: (context, state) {
          switch (state.status) {
            case UserProfileStatus.initial:
            case UserProfileStatus.loading:
              return const Center(
                child: CircularProgressIndicator(color: AppColor.primaryBlue),
              );
            case UserProfileStatus.error:
              return _ErrorState(message: state.errorMessage);
            case UserProfileStatus.loaded:
              final user = state.user;
              if (user == null) {
                return const _ErrorState(message: 'User not found.');
              }
              return RefreshIndicator(
                color: AppColor.primaryBlue,
                onRefresh: () async {
                  context.read<UserProfileBloc>().add(
                    const UserProfilePostsRefreshed(),
                  );
                  await context.read<UserProfileBloc>().stream.firstWhere(
                    (nextState) =>
                        nextState.postsStatus !=
                            UserProfilePostsStatus.loading &&
                        !nextState.isLoadingMorePosts,
                  );
                },
                child: ListView.builder(
                  controller: _scrollController,
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.only(bottom: 28),
                  itemCount: _itemCountFor(state),
                  itemBuilder: (context, index) {
                    if (index == 0) {
                      return _ProfileHeaderContent(user: user, state: state);
                    }
                    return _buildPostsItem(
                      context,
                      state,
                      index - 1,
                      context.read<SessionBloc>().state.user?.mssv,
                    );
                  },
                ),
              );
          }
        },
      ),
    );
  }

  int _itemCountFor(UserProfileState state) {
    if (state.postsStatus == UserProfilePostsStatus.loading &&
        state.posts.isEmpty) {
      return 4;
    }

    if (state.posts.isEmpty) {
      return 2;
    }

    var count = 1 + state.posts.length;
    if (state.isLoadingMorePosts ||
        (state.postsErrorMessage != null &&
            state.postsStatus == UserProfilePostsStatus.loaded)) {
      count += 1;
    }
    return count;
  }

  Widget _buildPostsItem(
    BuildContext context,
    UserProfileState state,
    int index,
    String? currentUserMssv,
  ) {
    if (state.postsStatus == UserProfilePostsStatus.loading &&
        state.posts.isEmpty) {
      return PostCardSkeleton(showImage: index == 1);
    }

    if (state.posts.isEmpty) {
      if (state.postsStatus == UserProfilePostsStatus.error) {
        return _PostsErrorState(
          message: state.postsErrorMessage,
          onRetry: () => context.read<UserProfileBloc>().add(
            const UserProfilePostsRefreshed(),
          ),
        );
      }
      return const _PostsEmptyState();
    }

    if (index >= state.posts.length) {
      return _PostsFooter(
        isLoading: state.isLoadingMorePosts,
        errorMessage: state.postsErrorMessage,
        onRetry: () => context.read<UserProfileBloc>().add(
          const UserProfilePostsLoadMore(),
        ),
      );
    }

    final post = state.posts[index];
    return PostCard(
      key: ValueKey('profile-${post.id}'),
      post: post,
      currentUserMssv: currentUserMssv,
      onLikeTap: () => context.read<UserProfileBloc>().add(
        UserProfilePostLiked(postId: post.id),
      ),
      onDeleteTap: () => context.read<UserProfileBloc>().add(
        UserProfilePostDeleted(postId: post.id),
      ),
      onEditTap: () => _navigateToEdit(context, post),
      onTap: () => _openPostDetail(context, post),
      onCommentTap: () => _openPostDetail(context, post),
    );
  }
}

class _ProfileHeaderContent extends StatelessWidget {
  const _ProfileHeaderContent({required this.user, required this.state});

  final OtherPeopleEntity user;
  final UserProfileState state;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 150,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppColor.primaryBlue.withValues(alpha: 0.18),
                  AppColor.primaryBlueDark.withValues(alpha: 0.08),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(24),
            ),
          ),
          Transform.translate(
            offset: const Offset(0, -42),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                _buildAvatar(),
                const SizedBox(width: 16),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          user.fullName,
                          style: AppTextStyle.h3.copyWith(
                            fontWeight: AppTextStyle.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          user.mssv,
                          style: AppTextStyle.bodySmall.copyWith(
                            color: AppColor.secondaryText,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Transform.translate(
            offset: const Offset(0, -18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if ((user.homeClassCode ?? '').isNotEmpty) ...[
                  _InfoChip(label: user.homeClassCode!),
                  const SizedBox(height: 16),
                ],
                _FriendStatusBanner(status: user.friendStatus),
                const SizedBox(height: 12),
                _ProfileActionBar(user: user, state: state),
                const SizedBox(height: 24),
                _InfoSection(
                  title: 'Bio',
                  value: (user.bio ?? '').trim().isEmpty
                      ? 'No bio yet.'
                      : user.bio!,
                ),
                const SizedBox(height: 14),
                _InfoSection(title: 'Email', value: user.email),
                if ((user.cometUid ?? '').isNotEmpty) ...[
                  const SizedBox(height: 14),
                  _InfoSection(title: 'Comet UID', value: user.cometUid!),
                ],
                const SizedBox(height: 24),
                Text(
                  'Bài viết',
                  style: AppTextStyle.h4.copyWith(
                    fontWeight: AppTextStyle.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAvatar() {
    final avatarUrl = user.avatarUrl;
    if (avatarUrl != null && avatarUrl.isNotEmpty) {
      return Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: AppColor.pureWhite, width: 4),
          boxShadow: const [
            BoxShadow(
              color: AppColor.shadowColor,
              blurRadius: 16,
              offset: Offset(0, 6),
            ),
          ],
        ),
        child: ClipOval(
          child: CachedNetworkImage(
            imageUrl: avatarUrl,
            width: 92,
            height: 92,
            fit: BoxFit.cover,
            errorWidget: (_, _, _) => _fallbackAvatar(),
          ),
        ),
      );
    }
    return _fallbackAvatar();
  }

  Widget _fallbackAvatar() {
    return Container(
      width: 92,
      height: 92,
      decoration: BoxDecoration(
        gradient: AppColor.blueAvatarGradient,
        shape: BoxShape.circle,
        border: Border.all(color: AppColor.pureWhite, width: 4),
        boxShadow: const [
          BoxShadow(
            color: AppColor.shadowColor,
            blurRadius: 16,
            offset: Offset(0, 6),
          ),
        ],
      ),
      alignment: Alignment.center,
      child: Text(
        user.userLetterAvatar,
        style: AppTextStyle.h2White.copyWith(fontWeight: AppTextStyle.bold),
      ),
    );
  }
}

class _PostsFooter extends StatelessWidget {
  const _PostsFooter({
    required this.isLoading,
    required this.errorMessage,
    required this.onRetry,
  });

  final bool isLoading;
  final String? errorMessage;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 20),
        child: Center(
          child: CircularProgressIndicator(
            strokeWidth: 2.5,
            color: AppColor.primaryBlue,
          ),
        ),
      );
    }

    if (errorMessage == null || errorMessage!.isEmpty) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColor.veryLightGrey,
          borderRadius: BorderRadius.circular(18),
        ),
        child: Column(
          children: [
            Text(
              errorMessage!,
              textAlign: TextAlign.center,
              style: AppTextStyle.bodySmall,
            ),
            const SizedBox(height: 12),
            TextButton(onPressed: onRetry, child: const Text('Thử lại')),
          ],
        ),
      ),
    );
  }
}

class _PostsEmptyState extends StatelessWidget {
  const _PostsEmptyState();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: AppColor.veryLightGrey,
          borderRadius: BorderRadius.circular(18),
        ),
        child: Text(
          'Người dùng chưa có bài viết nào.',
          textAlign: TextAlign.center,
          style: AppTextStyle.bodyMedium.copyWith(
            color: AppColor.secondaryText,
          ),
        ),
      ),
    );
  }
}

class _PostsErrorState extends StatelessWidget {
  const _PostsErrorState({required this.message, required this.onRetry});

  final String? message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: AppColor.veryLightGrey,
          borderRadius: BorderRadius.circular(18),
        ),
        child: Column(
          children: [
            const Icon(
              Icons.article_outlined,
              color: AppColor.alertRed,
              size: 30,
            ),
            const SizedBox(height: 10),
            Text(
              message ?? 'Failed to load posts.',
              textAlign: TextAlign.center,
              style: AppTextStyle.bodyMedium,
            ),
            const SizedBox(height: 12),
            TextButton(onPressed: onRetry, child: const Text('Thử lại')),
          ],
        ),
      ),
    );
  }
}

class _FriendStatusBanner extends StatelessWidget {
  const _FriendStatusBanner({required this.status});

  final FriendStatus status;

  @override
  Widget build(BuildContext context) {
    if (status == FriendStatus.none) return const SizedBox.shrink();

    final data = switch (status) {
      FriendStatus.pending => (
        icon: Icons.schedule_rounded,
        text: 'Friend request sent. You can cancel it anytime.',
        background: AppColor.veryLightGrey,
        foreground: AppColor.secondaryText,
      ),
      FriendStatus.requested => (
        icon: Icons.mark_email_unread_rounded,
        text: 'This user sent you a friend request.',
        background: AppColor.warningOrangeLight,
        foreground: AppColor.warningOrangeDark,
      ),
      FriendStatus.friends => (
        icon: Icons.verified_rounded,
        text: 'You are friends now.',
        background: AppColor.successGreen10,
        foreground: AppColor.successGreenDark,
      ),
      FriendStatus.none => (
        icon: Icons.person_add_alt_1_rounded,
        text: '',
        background: AppColor.pureWhite,
        foreground: AppColor.primaryText,
      ),
    };

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: data.background,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Icon(data.icon, color: data.foreground, size: 18),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              data.text,
              style: AppTextStyle.bodySmall.copyWith(
                color: data.foreground,
                fontWeight: AppTextStyle.medium,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ProfileActionBar extends StatelessWidget {
  const _ProfileActionBar({required this.user, required this.state});

  final OtherPeopleEntity user;
  final UserProfileState state;

  bool _isLoading(UserProfileFriendAction action) =>
      state.isFriendActionLoading && state.activeFriendAction == action;

  bool get _areActionsDisabled => state.isFriendActionLoading;

  @override
  Widget build(BuildContext context) {
    return switch (user.friendStatus) {
      FriendStatus.none => _buildSingleAction(
        context,
        action: UserProfileFriendAction.sendRequest,
        label: 'Add Friend',
        style: _ProfileActionButtonStyle.primary(),
      ),
      FriendStatus.pending => _buildSingleAction(
        context,
        action: UserProfileFriendAction.cancelRequest,
        label: 'Cancel Request',
        style: _ProfileActionButtonStyle.neutral(),
      ),
      FriendStatus.requested => Row(
        children: [
          Expanded(
            child: _ProfileActionButton(
              label: 'Accept',
              style: _ProfileActionButtonStyle.primary(),
              isLoading: _isLoading(UserProfileFriendAction.acceptRequest),
              onPressed: _areActionsDisabled
                  ? null
                  : () => _submitAction(
                      context,
                      UserProfileFriendAction.acceptRequest,
                    ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _ProfileActionButton(
              label: 'Reject',
              style: _ProfileActionButtonStyle.destructive(),
              isLoading: _isLoading(UserProfileFriendAction.rejectRequest),
              onPressed: _areActionsDisabled
                  ? null
                  : () => _submitAction(
                      context,
                      UserProfileFriendAction.rejectRequest,
                    ),
            ),
          ),
        ],
      ),
      FriendStatus.friends => Row(
        children: [
          Expanded(
            child: _ProfileActionButton(
              label: 'Unfriend',
              style: _ProfileActionButtonStyle.destructive(),
              isLoading: _isLoading(UserProfileFriendAction.unfriend),
              onPressed: _areActionsDisabled
                  ? null
                  : () => _confirmUnfriend(context),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _ProfileActionButton(
              label: 'Message',
              style: _ProfileActionButtonStyle.secondary(),
              onPressed: _areActionsDisabled
                  ? null
                  : () => _openMessage(context),
            ),
          ),
        ],
      ),
    };
  }

  Widget _buildSingleAction(
    BuildContext context, {
    required UserProfileFriendAction action,
    required String label,
    required _ProfileActionButtonStyle style,
  }) {
    return SizedBox(
      width: double.infinity,
      child: _ProfileActionButton(
        label: label,
        style: style,
        isLoading: _isLoading(action),
        onPressed: _areActionsDisabled
            ? null
            : () => _submitAction(context, action),
      ),
    );
  }

  void _submitAction(BuildContext context, UserProfileFriendAction action) {
    context.read<UserProfileBloc>().add(
      UserProfileFriendActionSubmitted(action: action),
    );
  }

  Future<void> _confirmUnfriend(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Remove Friend'),
          content: Text('Remove ${user.fullName} from your friend list?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(false),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(true),
              style: TextButton.styleFrom(foregroundColor: AppColor.alertRed),
              child: const Text('Unfriend'),
            ),
          ],
        );
      },
    );

    if (confirmed == true && context.mounted) {
      _submitAction(context, UserProfileFriendAction.unfriend);
    }
  }

  void _openMessage(BuildContext context) {
    final cometUid = user.cometUid?.trim() ?? user.mssv.trim();
    if (cometUid.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Messaging is unavailable for this user.'),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    final conversation = ConversationEntity(
      id: cometUid,
      name: user.fullName,
      avatarUrl: user.avatarUrl ?? '',
      lastMessage: '',
      time: '',
      isGroup: false,
      isOnline: false,
      conversationType: 'user',
    );

    
  }
}

class _ProfileActionButton extends StatelessWidget {
  const _ProfileActionButton({
    required this.label,
    required this.style,
    this.isLoading = false,
    this.onPressed,
  });

  final String label;
  final _ProfileActionButtonStyle style;
  final bool isLoading;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: style.backgroundColor,
        foregroundColor: style.foregroundColor,
        disabledBackgroundColor: style.backgroundColor,
        disabledForegroundColor: style.foregroundColor,
        elevation: 0,
        side: BorderSide(color: style.borderColor),
        minimumSize: const Size.fromHeight(48),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        textStyle: AppTextStyle.bodySmall.copyWith(
          fontWeight: AppTextStyle.medium,
        ),
      ),
      child: isLoading
          ? SizedBox(
              width: 18,
              height: 18,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: style.foregroundColor,
              ),
            )
          : Text(label),
    );
  }
}

class _ProfileActionButtonStyle {
  const _ProfileActionButtonStyle({
    required this.backgroundColor,
    required this.foregroundColor,
    required this.borderColor,
  });

  final Color backgroundColor;
  final Color foregroundColor;
  final Color borderColor;

  factory _ProfileActionButtonStyle.primary() {
    return const _ProfileActionButtonStyle(
      backgroundColor: AppColor.primaryBlue,
      foregroundColor: AppColor.pureWhite,
      borderColor: AppColor.primaryBlue,
    );
  }

  factory _ProfileActionButtonStyle.secondary() {
    return const _ProfileActionButtonStyle(
      backgroundColor: AppColor.pureWhite,
      foregroundColor: AppColor.primaryBlue,
      borderColor: AppColor.primaryBlue,
    );
  }

  factory _ProfileActionButtonStyle.neutral() {
    return const _ProfileActionButtonStyle(
      backgroundColor: AppColor.veryLightGrey,
      foregroundColor: AppColor.secondaryText,
      borderColor: AppColor.dividerGrey,
    );
  }

  factory _ProfileActionButtonStyle.destructive() {
    return _ProfileActionButtonStyle(
      backgroundColor: AppColor.alertRed10,
      foregroundColor: AppColor.alertRed,
      borderColor: AppColor.alertRed.withValues(alpha: 0.2),
    );
  }
}

class _InfoSection extends StatelessWidget {
  const _InfoSection({required this.title, required this.value});

  final String title;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColor.veryLightGrey,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: AppTextStyle.captionLarge.copyWith(
              color: AppColor.secondaryText,
            ),
          ),
          const SizedBox(height: 6),
          Text(value, style: AppTextStyle.bodyMedium),
        ],
      ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  const _InfoChip({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: AppColor.primaryBlue10,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: AppTextStyle.captionLarge.copyWith(
          color: AppColor.primaryBlue,
          fontWeight: AppTextStyle.medium,
        ),
      ),
    );
  }
}

class _ErrorState extends StatelessWidget {
  const _ErrorState({required this.message});

  final String? message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.person_off_outlined,
              color: AppColor.alertRed,
              size: 46,
            ),
            const SizedBox(height: 14),
            Text(
              message ?? 'Failed to load user profile.',
              textAlign: TextAlign.center,
              style: AppTextStyle.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }
}

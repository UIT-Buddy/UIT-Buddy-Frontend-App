import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uit_buddy_mobile/app/di/app_dependencies.dart';
import 'package:uit_buddy_mobile/core/theme/app_color.dart';
import 'package:uit_buddy_mobile/core/theme/app_text_style.dart';
import 'package:uit_buddy_mobile/features/profile/domain/entities/friend_entity.dart';
import 'package:uit_buddy_mobile/features/profile/presentation/bloc/your_friends_screen/friends_bloc.dart';
import 'package:uit_buddy_mobile/features/profile/presentation/bloc/your_friends_screen/friends_event.dart';
import 'package:uit_buddy_mobile/features/profile/presentation/bloc/your_friends_screen/friends_state.dart';
import 'package:uit_buddy_mobile/features/profile/presentation/widgets/friends/friend_item_tile.dart';
import 'package:uit_buddy_mobile/features/profile/presentation/widgets/friends/friends_header.dart';
import 'package:uit_buddy_mobile/features/profile/presentation/widgets/friends/friends_search_bar.dart';
import 'package:uit_buddy_mobile/features/profile/presentation/widgets/friends/friends_tabs.dart';
import 'package:uit_buddy_mobile/features/social/presentation/screens/user_profile_screen.dart';

class YourFriendsScreen extends StatelessWidget {
  const YourFriendsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => serviceLocator<FriendsBloc>()..add(const FriendsLoaded()),
      child: const _YourFriendsView(),
    );
  }
}

class _YourFriendsView extends StatefulWidget {
  const _YourFriendsView();

  @override
  State<_YourFriendsView> createState() => _YourFriendsViewState();
}

class _YourFriendsViewState extends State<_YourFriendsView> {
  late final TextEditingController _searchController;
  late final ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    _searchController.addListener(_onSearchChanged);

    _scrollController = ScrollController()..addListener(_onScroll);
  }

  @override
  void dispose() {
    _searchController
      ..removeListener(_onSearchChanged)
      ..dispose();
    _scrollController
      ..removeListener(_onScroll)
      ..dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    context.read<FriendsBloc>().add(
      FriendsSearchChanged(query: _searchController.text),
    );
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;
    final position = _scrollController.position;
    if (position.pixels >= position.maxScrollExtent - 180) {
      context.read<FriendsBloc>().add(const FriendsLoadMore());
    }
  }

  Future<void> _onRefresh() async {
    context.read<FriendsBloc>().add(const FriendsRefreshed());
    await context.read<FriendsBloc>().stream.firstWhere(
      (state) => state.status != FriendsStatus.loading && !state.isLoadingMore,
    );
  }

  Future<void> _openProfile(FriendEntity friend) async {
    await Navigator.of(context).push<void>(
      MaterialPageRoute(builder: (_) => UserProfileScreen(mssv: friend.mssv)),
    );
  }

  Future<void> _confirmUnfriend(FriendEntity friend) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Unfriend'),
        content: Text('Unfriend ${friend.name}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            style: TextButton.styleFrom(foregroundColor: AppColor.alertRed),
            child: const Text('Unfriend'),
          ),
        ],
      ),
    );

    if (!mounted || confirmed != true) return;
    context.read<FriendsBloc>().add(FriendsUnfriend(friendMssv: friend.mssv));
  }

  Future<void> _showRespondOptions(FriendEntity friend) async {
    final action = await showModalBottomSheet<String>(
      context: context,
      backgroundColor: AppColor.pureWhite,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (ctx) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 8),
              Container(
                width: 36,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColor.dividerGrey,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'Respond to Invite',
                style: AppTextStyle.bodyLarge.copyWith(
                  fontWeight: AppTextStyle.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(friend.name, style: AppTextStyle.captionLarge),
              const SizedBox(height: 10),
              ListTile(
                leading: const Icon(
                  Icons.check_circle,
                  color: AppColor.successGreen,
                ),
                title: const Text('Accept'),
                onTap: () => Navigator.of(ctx).pop('ACCEPT'),
              ),
              ListTile(
                leading: const Icon(Icons.cancel, color: AppColor.alertRed),
                title: const Text('Reject'),
                onTap: () => Navigator.of(ctx).pop('REJECT'),
              ),
              const SizedBox(height: 8),
            ],
          ),
        );
      },
    );

    if (!mounted || action == null) return;
    context.read<FriendsBloc>().add(
      FriendsRespondToFriendRequest(senderMssv: friend.mssv, action: action),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.veryLightGrey,
      body: SafeArea(
        child: BlocConsumer<FriendsBloc, FriendsState>(
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
              context.read<FriendsBloc>().add(const FriendsFeedbackCleared());
              return;
            }

            if (state.actionSuccessMessage != null) {
              messenger
                ..hideCurrentSnackBar()
                ..showSnackBar(
                  SnackBar(
                    content: Text(state.actionSuccessMessage!),
                    backgroundColor: AppColor.successGreen,
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              context.read<FriendsBloc>().add(const FriendsFeedbackCleared());
            }
          },
          builder: (context, state) {
            return Column(
              children: [
                FriendsHeader(
                  onBack: () => Navigator.of(context).pop(),
                  title: 'Friends',
                ),
                const SizedBox(height: 8),
                FriendsPrimaryTabs(
                  current: state.curSection,
                  onChanged: (tab) => context.read<FriendsBloc>().add(
                    FriendsPrimaryTabChanged(tab: tab),
                  ),
                ),
                if (state.curSection == FriendsPrimaryTab.invites) ...[
                  const SizedBox(height: 10),
                  FriendsInviteTabs(
                    current: state.curInviteSection,
                    onChanged: (tab) => context.read<FriendsBloc>().add(
                      FriendsInviteTabChanged(tab: tab),
                    ),
                  ),
                ],
                const SizedBox(height: 10),
                FriendsSearchBar(
                  controller: _searchController,
                  hintText: state.curSection == FriendsPrimaryTab.friends
                      ? 'Search by name...'
                      : 'Search...',
                  showClear: state.searchQuery.trim().isNotEmpty,
                ),
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      '${state.filtered.length} ${_sectionLabel(state)}',
                      style: AppTextStyle.bodySmall.copyWith(
                        fontWeight: AppTextStyle.bold,
                        color: AppColor.primaryText,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Expanded(child: _buildContent(state)),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildContent(FriendsState state) {
    final activeItems = state.activeItems;
    final showInitialLoading =
        state.status == FriendsStatus.loading && activeItems.isEmpty;
    final showError =
        state.status == FriendsStatus.error && activeItems.isEmpty;

    if (showInitialLoading) {
      return const Center(
        child: CircularProgressIndicator(color: AppColor.primaryBlue),
      );
    }

    if (showError) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, color: AppColor.alertRed, size: 44),
            const SizedBox(height: 10),
            Text(
              state.errorMessage ?? 'Something went wrong.',
              style: AppTextStyle.bodyMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            TextButton(
              onPressed: () =>
                  context.read<FriendsBloc>().add(const FriendsRefreshed()),
              child: const Text('Try again'),
            ),
          ],
        ),
      );
    }

    if (state.filtered.isEmpty) {
      return Center(
        child: Text(
          _emptyText(state),
          style: AppTextStyle.bodySmall.copyWith(color: AppColor.secondaryText),
        ),
      );
    }

    final itemCount = state.filtered.length + (state.isLoadingMore ? 1 : 0);

    return RefreshIndicator(
      color: AppColor.primaryBlue,
      onRefresh: _onRefresh,
      child: ListView.builder(
        controller: _scrollController,
        padding: const EdgeInsets.only(bottom: 12),
        itemCount: itemCount,
        itemBuilder: (context, index) {
          if (index == state.filtered.length) {
            return const Padding(
              padding: EdgeInsets.symmetric(vertical: 16),
              child: Center(
                child: CircularProgressIndicator(
                  strokeWidth: 2.5,
                  color: AppColor.primaryBlue,
                ),
              ),
            );
          }

          final friend = state.filtered[index];
          final isFriendsTab = state.curSection == FriendsPrimaryTab.friends;
          final isSentTab =
              state.curSection == FriendsPrimaryTab.invites &&
              state.curInviteSection == FriendsInviteTab.sent;
          final isReceivedTab =
              state.curSection == FriendsPrimaryTab.invites &&
              state.curInviteSection == FriendsInviteTab.received;

          final actionLabel = isSentTab
              ? 'Cancel'
              : isReceivedTab
              ? 'Respond'
              : null;

          final isActionLoading =
              state.isPerformingAction && state.activeActionMssv == friend.mssv;

          return FriendItemTile(
            friend: friend,
            showUnfriendAction: isFriendsTab,
            actionLabel: actionLabel,
            isActionLoading: isActionLoading,
            disableActions: state.isPerformingAction,
            onViewProfile: () => _openProfile(friend),
            onUnfriend: () => _confirmUnfriend(friend),
            onActionPressed: actionLabel == null
                ? null
                : () {
                    if (isSentTab) {
                      context.read<FriendsBloc>().add(
                        FriendsToggleFriendRequest(receiverMssv: friend.mssv),
                      );
                    } else if (isReceivedTab) {
                      _showRespondOptions(friend);
                    }
                  },
          );
        },
      ),
    );
  }

  String _sectionLabel(FriendsState state) {
    if (state.curSection == FriendsPrimaryTab.friends) {
      return state.filtered.length == 1 ? 'friend' : 'friends';
    }

    if (state.curInviteSection == FriendsInviteTab.sent) {
      return state.filtered.length == 1 ? 'sent invite' : 'sent invites';
    }

    return state.filtered.length == 1 ? 'received invite' : 'received invites';
  }

  String _emptyText(FriendsState state) {
    if (state.searchQuery.trim().isNotEmpty) {
      return 'No users found.';
    }

    if (state.curSection == FriendsPrimaryTab.friends) {
      return 'You have no friends yet.';
    }

    if (state.curInviteSection == FriendsInviteTab.sent) {
      return 'No sent invites.';
    }

    return 'No received invites.';
  }
}

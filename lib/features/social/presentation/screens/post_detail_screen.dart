import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uit_buddy_mobile/app/di/app_dependencies.dart';
import 'package:uit_buddy_mobile/core/theme/app_color.dart';
import 'package:uit_buddy_mobile/core/theme/app_text_style.dart';
import 'package:uit_buddy_mobile/features/session/presentation/bloc/session_bloc.dart';
import 'package:uit_buddy_mobile/features/social/domain/entities/post_entity.dart';
import 'package:uit_buddy_mobile/features/social/presentation/bloc/post_detail/post_detail_bloc.dart';
import 'package:uit_buddy_mobile/features/social/presentation/bloc/post_detail/post_detail_event.dart';
import 'package:uit_buddy_mobile/features/social/presentation/bloc/post_detail/post_detail_state.dart';
import 'package:uit_buddy_mobile/features/social/presentation/constants/post_detail_text.dart';
import 'package:uit_buddy_mobile/features/social/presentation/screens/edit_post_screen.dart';
import 'package:uit_buddy_mobile/features/social/presentation/widgets/comments/comment_input_bar.dart';
import 'package:uit_buddy_mobile/features/social/presentation/widgets/comments/comment_item.dart';
import 'package:uit_buddy_mobile/features/social/presentation/widgets/post_card.dart';

class PostDetailScreen extends StatelessWidget {
  final String postId;
  final PostEntity? initialPost;

  const PostDetailScreen({super.key, required this.postId, this.initialPost});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => serviceLocator<PostDetailBloc>()
        ..add(PostDetailStarted(postId: postId, initialPost: initialPost)),
      child: const _PostDetailView(),
    );
  }
}

class _PostDetailView extends StatefulWidget {
  const _PostDetailView();

  @override
  State<_PostDetailView> createState() => _PostDetailViewState();
}

class _PostDetailViewState extends State<_PostDetailView> {
  late final ScrollController _scrollController;
  late final FocusNode _commentFocusNode;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _commentFocusNode = FocusNode();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_onScroll)
      ..dispose();
    _commentFocusNode.dispose();
    super.dispose();
  }

  Future<void> _navigateToEdit(BuildContext context, PostEntity post) async {
    final bloc = context.read<PostDetailBloc>();
    final updated = await Navigator.of(context).push<PostEntity>(
      MaterialPageRoute(builder: (_) => EditPostScreen(post: post)),
    );
    if (updated != null) {
      bloc.add(PostDetailPostEdited(updatedPost: updated));
    }
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;
    final pos = _scrollController.position;
    if (pos.pixels >= pos.maxScrollExtent - 200) {
      context.read<PostDetailBloc>().add(const PostDetailCommentsLoadMore());
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PostDetailBloc, PostDetailState>(
      listenWhen: (prev, curr) =>
          curr.submitCommentError != null &&
          prev.submitCommentError != curr.submitCommentError,
      listener: (context, state) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              state.submitCommentError ?? PostDetailText.genericError,
            ),
            backgroundColor: AppColor.alertRed,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          ),
        );
      },
      builder: (context, state) {
        final sessionState = context.read<SessionBloc>().state;
        final currentUser = sessionState.user;
        final currentMssv = currentUser?.mssv;

        return Scaffold(
          backgroundColor: AppColor.pureWhite,
          appBar: AppBar(
            backgroundColor: AppColor.pureWhite,
            elevation: 0,
            scrolledUnderElevation: 1,
            shadowColor: AppColor.shadowColor,
            surfaceTintColor: Colors.transparent,
            leading: IconButton(
              icon: const Icon(
                Icons.arrow_back_ios_new_rounded,
                size: 18,
                color: AppColor.primaryText,
              ),
              onPressed: () => Navigator.of(context).pop(),
            ),
            title: Text(
              PostDetailText.screenTitle,
              style: AppTextStyle.bodyMedium.copyWith(
                fontWeight: AppTextStyle.bold,
              ),
            ),
            centerTitle: true,
            bottom: const PreferredSize(
              preferredSize: Size.fromHeight(1),
              child: Divider(
                height: 1,
                thickness: 1,
                color: AppColor.dividerGrey,
              ),
            ),
          ),
          body: Column(
            children: [
              Expanded(
                child: _buildScrollView(context, state, currentMssv),
              ),
              BlocBuilder<PostDetailBloc, PostDetailState>(
                buildWhen: (prev, curr) =>
                    prev.isSubmittingComment != curr.isSubmittingComment ||
                    prev.replyingToCommentId != curr.replyingToCommentId ||
                    prev.replyingToAuthorName != curr.replyingToAuthorName,
                builder: (context, s) => CommentInputBar(
                  replyingToCommentId: s.replyingToCommentId,
                  replyingToAuthorName: s.replyingToAuthorName,
                  isSubmitting: s.isSubmittingComment,
                  avatarUrl: currentUser?.avatarUrl,
                  avatarLetter: currentUser?.userLetterAvatar ?? 'U',
                  focusNode: _commentFocusNode,
                  onCancelReply: () => context
                      .read<PostDetailBloc>()
                      .add(const PostDetailReplyCancelled()),
                  onSubmit: (content) {
                    final bloc = context.read<PostDetailBloc>();
                    final replyId = bloc.state.replyingToCommentId;
                    if (replyId != null) {
                      bloc.add(
                        PostDetailReplySubmitted(
                          commentId: replyId,
                          content: content,
                        ),
                      );
                    } else {
                      bloc.add(PostDetailCommentSubmitted(content: content));
                    }
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildScrollView(
    BuildContext context,
    PostDetailState state,
    String? currentMssv,
  ) {
    if (state.isPostLoading && state.post == null) {
      return const Center(
        child: CircularProgressIndicator(
          strokeWidth: 2.5,
          color: AppColor.primaryBlue,
        ),
      );
    }

    if (state.errorMessage != null && !state.isPostLoading && state.post == null) {
      return _buildErrorState(context, state);
    }

    return CustomScrollView(
      controller: _scrollController,
      slivers: [
        // ── Post card ──────────────────────────────────────────────────────
        if (state.post != null)
          SliverToBoxAdapter(
            child: PostCard(
              post: state.post!,
              currentUserMssv: currentMssv,
              onLikeTap: () => context
                  .read<PostDetailBloc>()
                  .add(const PostDetailPostLikeToggled()),
              onCommentTap: () => _commentFocusNode.requestFocus(),
              onDeleteTap: null,
              onEditTap: () => _navigateToEdit(context, state.post!),
            ),
          ),

        // ── Comments header ────────────────────────────────────────────────
        SliverToBoxAdapter(
          child: _buildCommentsHeader(state),
        ),

        // ── Comments list ─────────────────────────────────────────────────
        if (state.comments.isEmpty && !state.isPostLoading && !state.isCommentsLoading)
          SliverToBoxAdapter(child: _buildEmptyComments())
        else
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                final comment = state.comments[index];
                return CommentItemWidget(
                  key: ValueKey(comment.id),
                  comment: comment,
                  currentUserMssv: currentMssv,
                  loadedReplies: state.replies[comment.id],
                  isLoadingReplies:
                      state.loadingReplies[comment.id] ?? false,
                  onLikeTap: () => context.read<PostDetailBloc>().add(
                    PostDetailCommentLikeToggled(commentId: comment.id),
                  ),
                  onReplyTap: () => context.read<PostDetailBloc>().add(
                    PostDetailReplyingSet(
                      commentId: comment.id,
                      authorName: comment.author?.fullName ?? 'Ẩn danh',
                    ),
                  ),
                  onDeleteTap: () => context.read<PostDetailBloc>().add(
                    PostDetailCommentDeleted(commentId: comment.id),
                  ),
                  onViewRepliesTap: () => context.read<PostDetailBloc>().add(
                    PostDetailRepliesLoaded(commentId: comment.id),
                  ),
                  onReplyLikeTap: (replyId) =>
                      context.read<PostDetailBloc>().add(
                        PostDetailCommentLikeToggled(commentId: replyId),
                      ),
                  onReplyDeleteTap: (replyId) =>
                      context.read<PostDetailBloc>().add(
                        PostDetailCommentDeleted(commentId: replyId),
                      ),
                );
              },
              childCount: state.comments.length,
            ),
          ),

        // ── Load more ─────────────────────────────────────────────────────
        SliverToBoxAdapter(
          child: _buildLoadMoreIndicator(state),
        ),

        const SliverToBoxAdapter(child: SizedBox(height: 20)),
      ],
    );
  }

  Widget _buildErrorState(BuildContext context, PostDetailState state) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                color: AppColor.alertRed10,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.error_outline_rounded,
                color: AppColor.alertRed,
                size: 36,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              state.errorMessage ?? PostDetailText.errorLoadingPost,
              style: AppTextStyle.bodyMedium.copyWith(
                color: AppColor.secondaryText,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: () {
                if (state.post != null) {
                  context.read<PostDetailBloc>().add(
                    PostDetailStarted(postId: state.post!.id),
                  );
                }
              },
              icon: const Icon(Icons.refresh_rounded, size: 18),
              label: const Text(PostDetailText.retry),
              style: FilledButton.styleFrom(
                backgroundColor: AppColor.primaryBlue,
                foregroundColor: AppColor.pureWhite,
                textStyle: AppTextStyle.bodySmall.copyWith(
                  fontWeight: AppTextStyle.medium,
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyComments() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 48, horizontal: 32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.chat_bubble_outline_rounded,
            size: 44,
            color: AppColor.tertiaryText,
          ),
          const SizedBox(height: 12),
          Text(
            PostDetailText.noComments,
            style: AppTextStyle.captionLarge,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildCommentsHeader(PostDetailState state) {
    final count = state.post?.commentCount ?? state.comments.length;
    return Container(
      margin: const EdgeInsets.only(top: 4),
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 10),
      child: Row(
        children: [
          const Icon(
            Icons.chat_bubble_outline_rounded,
            size: 16,
            color: AppColor.primaryBlue,
          ),
          const SizedBox(width: 8),
          Text(
            'Comments',
            style: AppTextStyle.bodySmall.copyWith(
              fontWeight: AppTextStyle.bold,
            ),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(
              color: AppColor.primaryBlue10,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              '$count',
              style: AppTextStyle.captionSmall.copyWith(
                color: AppColor.primaryBlue,
                fontWeight: AppTextStyle.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadMoreIndicator(PostDetailState state) {
    if (state.isLoadingMoreComments) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 16),
        child: Center(
          child: CircularProgressIndicator(
            strokeWidth: 2,
            color: AppColor.primaryBlue,
          ),
        ),
      );
    }
    if (!state.hasMoreComments && state.comments.isNotEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 24),
        child: Row(
          children: [
            const Expanded(
              child: Divider(color: AppColor.dividerGrey),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Text(
                PostDetailText.allCommentsShown,
                style: AppTextStyle.captionMedium,
              ),
            ),
            const Expanded(
              child: Divider(color: AppColor.dividerGrey),
            ),
          ],
        ),
      );
    }
    return const SizedBox.shrink();
  }
}

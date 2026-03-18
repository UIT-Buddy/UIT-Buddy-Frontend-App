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
          ),
        );
      },
      builder: (context, state) {
        final sessionState = context.read<SessionBloc>().state;
        final currentUser = sessionState.user;
        final currentMssv = currentUser?.mssv;

        return Scaffold(
          backgroundColor: AppColor.veryLightGrey,
          appBar: AppBar(
            backgroundColor: AppColor.pureWhite,
            elevation: 0,
            scrolledUnderElevation: 0.5,
            shadowColor: AppColor.shadowColor,
            leading: IconButton(
              icon: const Icon(
                Icons.arrow_back_ios_new,
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
    if (state.status == PostDetailStatus.loading && state.post == null) {
      return const Center(
        child: CircularProgressIndicator(
          strokeWidth: 2.5,
          color: AppColor.primaryBlue,
        ),
      );
    }

    if (state.status == PostDetailStatus.error && state.post == null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline,
              color: AppColor.alertRed,
              size: 48,
            ),
            const SizedBox(height: 12),
            Text(
              state.errorMessage ?? PostDetailText.errorLoadingPost,
              style: AppTextStyle.bodyMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            TextButton(
              onPressed: () {
                if (state.post != null) {
                  context.read<PostDetailBloc>().add(
                    PostDetailStarted(postId: state.post!.id),
                  );
                }
              },
              child: const Text(PostDetailText.retry),
            ),
          ],
        ),
      );
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
        if (state.comments.isEmpty && state.status == PostDetailStatus.loaded)
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 32),
              child: Center(
                child: Text(
                  PostDetailText.noComments,
                  style: AppTextStyle.captionLarge,
                ),
              ),
            ),
          )
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

        const SliverToBoxAdapter(child: SizedBox(height: 16)),
      ],
    );
  }

  Widget _buildCommentsHeader(PostDetailState state) {
    final count = state.post?.commentCount ?? state.comments.length;
    return Container(
      color: AppColor.pureWhite,
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      margin: const EdgeInsets.only(top: 8),
      child: Text(
        PostDetailText.commentsHeader(count),
        style: AppTextStyle.bodySmall.copyWith(
          fontWeight: AppTextStyle.bold,
        ),
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
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Center(
          child: Text(PostDetailText.allCommentsShown, style: AppTextStyle.captionMedium),
        ),
      );
    }
    return const SizedBox.shrink();
  }
}

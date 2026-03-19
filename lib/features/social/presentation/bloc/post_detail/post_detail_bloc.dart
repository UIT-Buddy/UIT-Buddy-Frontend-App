import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uit_buddy_mobile/features/social/domain/entities/comment_entity.dart';
import 'package:uit_buddy_mobile/features/social/domain/entities/post_entity.dart';
import 'package:uit_buddy_mobile/features/social/domain/usecases/create_comment_usecase.dart';
import 'package:uit_buddy_mobile/features/social/domain/usecases/delete_comment_usecase.dart';
import 'package:uit_buddy_mobile/features/social/domain/usecases/get_comment_replies_usecase.dart';
import 'package:uit_buddy_mobile/features/social/domain/usecases/get_post_comments_usecase.dart';
import 'package:uit_buddy_mobile/features/social/domain/usecases/get_post_detail_usecase.dart';
import 'package:uit_buddy_mobile/features/social/domain/usecases/reply_to_comment_usecase.dart';
import 'package:uit_buddy_mobile/features/social/domain/usecases/toggle_comment_like_usecase.dart';
import 'package:uit_buddy_mobile/features/social/domain/usecases/toggle_like_usecase.dart';
import 'package:uit_buddy_mobile/features/social/presentation/bloc/post_detail/post_detail_event.dart';
import 'package:uit_buddy_mobile/features/social/presentation/bloc/post_detail/post_detail_state.dart';

class PostDetailBloc extends Bloc<PostDetailEvent, PostDetailState> {
  PostDetailBloc({
    required GetPostDetailUsecase getPostDetailUsecase,
    required GetPostCommentsUsecase getPostCommentsUsecase,
    required CreateCommentUsecase createCommentUsecase,
    required ReplyToCommentUsecase replyToCommentUsecase,
    required DeleteCommentUsecase deleteCommentUsecase,
    required ToggleCommentLikeUsecase toggleCommentLikeUsecase,
    required GetCommentRepliesUsecase getCommentRepliesUsecase,
    required ToggleLikeUsecase toggleLikeUsecase,
  }) : _getPostDetailUsecase = getPostDetailUsecase,
       _getPostCommentsUsecase = getPostCommentsUsecase,
       _createCommentUsecase = createCommentUsecase,
       _replyToCommentUsecase = replyToCommentUsecase,
       _deleteCommentUsecase = deleteCommentUsecase,
       _toggleCommentLikeUsecase = toggleCommentLikeUsecase,
       _getCommentRepliesUsecase = getCommentRepliesUsecase,
       _toggleLikeUsecase = toggleLikeUsecase,
       super(const PostDetailState()) {
    on<PostDetailStarted>(_onStarted);
    on<PostDetailPostLikeToggled>(_onPostLikeToggled);
    on<PostDetailCommentSubmitted>(_onCommentSubmitted);
    on<PostDetailReplySubmitted>(_onReplySubmitted);
    on<PostDetailCommentLikeToggled>(_onCommentLikeToggled);
    on<PostDetailCommentDeleted>(_onCommentDeleted);
    on<PostDetailCommentsLoadMore>(_onCommentsLoadMore);
    on<PostDetailRepliesLoaded>(_onRepliesLoaded);
    on<PostDetailReplyingSet>(_onReplyingSet);
    on<PostDetailReplyCancelled>(_onReplyCancelled);
    on<PostDetailPostEdited>(_onPostEdited);
  }

  final GetPostDetailUsecase _getPostDetailUsecase;
  final GetPostCommentsUsecase _getPostCommentsUsecase;
  final CreateCommentUsecase _createCommentUsecase;
  final ReplyToCommentUsecase _replyToCommentUsecase;
  final DeleteCommentUsecase _deleteCommentUsecase;
  final ToggleCommentLikeUsecase _toggleCommentLikeUsecase;
  final GetCommentRepliesUsecase _getCommentRepliesUsecase;
  final ToggleLikeUsecase _toggleLikeUsecase;

  // ─── Post ──────────────────────────────────────────────────────────────────

  Future<void> _onStarted(
    PostDetailStarted event,
    Emitter<PostDetailState> emit,
  ) async {
    emit(state.copyWith(isPostLoading: true, post: event.initialPost));

    final postResult = await _getPostDetailUsecase(
      GetPostDetailParams(postId: event.postId),
    );

    PostEntity? post;
    postResult.fold(
      (failure) => emit(
        state.copyWith(isPostLoading: false, errorMessage: failure.message),
      ),
      (p) => post = p,
    );
    if (post == null) return;

    emit(state.copyWith(isPostLoading: false, post: post));

    await _onRefreshComments(post!.id, emit);
  }

  Future<void> _onRefreshComments(
    String postId,
    Emitter<PostDetailState> emit,
  ) async {
    emit(state.copyWith(isCommentsLoading: true));

    final commentsResult = await _getPostCommentsUsecase(
      GetPostCommentsParams(postId: postId),
    );
    commentsResult.fold(
      (_) => emit(state.copyWith(isCommentsLoading: false)),
      (paged) => emit(
        state.copyWith(
          isCommentsLoading: false,
          comments: paged.items,
          commentsCursor: paged.nextCursor,
          hasMoreComments: paged.hasMore,
        ),
      ),
    );
  }

  Future<void> _onPostLikeToggled(
    PostDetailPostLikeToggled event,
    Emitter<PostDetailState> emit,
  ) async {
    if (state.post == null) return;

    final previousPost = state.post!;
    final isLiked = previousPost.isLiked;

    emit(
      state.copyWith(
        post: previousPost.copyWith(
          isLiked: !isLiked,
          likeCount: isLiked
              ? previousPost.likeCount - 1
              : previousPost.likeCount + 1,
        ),
      ),
    );

    final result = await _toggleLikeUsecase(
      ToggleLikeParams(postId: previousPost.id),
    );
    result.fold((_) => emit(state.copyWith(post: previousPost)), (_) {});
  }

  // ─── Comments ──────────────────────────────────────────────────────────────

  Future<void> _onCommentSubmitted(
    PostDetailCommentSubmitted event,
    Emitter<PostDetailState> emit,
  ) async {
    final postId = state.post?.id;
    if (postId == null) return;

    emit(state.copyWith(isSubmittingComment: true, submitCommentError: null));

    final result = await _createCommentUsecase(
      CreateCommentParams(postId: postId, content: event.content),
    );

    bool success = false;
    result.fold(
      (failure) => emit(
        state.copyWith(
          isSubmittingComment: false,
          submitCommentError: failure.message,
        ),
      ),
      (_) {
        success = true;
         _onRefreshComments(postId, emit);
      },
    );
    if (!success) return;

    // Refresh comment list from page 1
    final commentsResult = await _getPostCommentsUsecase(
      GetPostCommentsParams(postId: postId),
    );
    commentsResult.fold(
      (_) => emit(
        state.copyWith(
          isSubmittingComment: false,
          replyingToCommentId: null,
          replyingToAuthorName: null,
        ),
      ),
      (paged) => emit(
        state.copyWith(
          isSubmittingComment: false,
          replyingToCommentId: null,
          replyingToAuthorName: null,
          comments: paged.items,
          commentsCursor: paged.nextCursor,
          hasMoreComments: paged.hasMore,
        ),
      ),
    );
  }

  Future<void> _onReplySubmitted(
    PostDetailReplySubmitted event,
    Emitter<PostDetailState> emit,
  ) async {
    emit(state.copyWith(isSubmittingComment: true, submitCommentError: null));

    final result = await _replyToCommentUsecase(
      ReplyToCommentParams(commentId: event.commentId, content: event.content),
    );

    bool success = false;
    result.fold(
      (failure) => emit(
        state.copyWith(
          isSubmittingComment: false,
          submitCommentError: failure.message,
        ),
      ),
      (_) => success = true,
    );
    if (!success) return;

    // Increment reply count on the parent comment
    final updatedComments = state.comments.map((c) {
      if (c.id == event.commentId) {
        return c.copyWith(replyCount: c.replyCount + 1);
      }
      return c;
    }).toList();

    // Reload replies for this comment
    final repliesResult = await _getCommentRepliesUsecase(
      GetCommentRepliesParams(commentId: event.commentId),
    );
    repliesResult.fold(
      (_) => emit(
        state.copyWith(
          isSubmittingComment: false,
          replyingToCommentId: null,
          replyingToAuthorName: null,
          comments: updatedComments,
        ),
      ),
      (paged) => emit(
        state.copyWith(
          isSubmittingComment: false,
          replyingToCommentId: null,
          replyingToAuthorName: null,
          comments: updatedComments,
          replies: {...state.replies, event.commentId: paged.items},
        ),
      ),
    );
  }

  Future<void> _onCommentLikeToggled(
    PostDetailCommentLikeToggled event,
    Emitter<PostDetailState> emit,
  ) async {
    final previousComments = state.comments;
    final previousReplies = state.replies;

    CommentEntity _toggle(CommentEntity c) {
      if (c.id != event.commentId) return c;
      return c.copyWith(
        isLiked: !c.isLiked,
        likeCount: c.isLiked ? c.likeCount - 1 : c.likeCount + 1,
      );
    }

    final updatedReplies = <String, List<CommentEntity>>{};
    for (final entry in state.replies.entries) {
      updatedReplies[entry.key] = entry.value.map(_toggle).toList();
    }

    emit(
      state.copyWith(
        comments: previousComments.map(_toggle).toList(),
        replies: updatedReplies,
      ),
    );

    final result = await _toggleCommentLikeUsecase(
      ToggleCommentLikeParams(commentId: event.commentId),
    );
    result.fold(
      (_) => emit(
        state.copyWith(comments: previousComments, replies: previousReplies),
      ),
      (_) {},
    );
  }

  Future<void> _onCommentDeleted(
    PostDetailCommentDeleted event,
    Emitter<PostDetailState> emit,
  ) async {
    final previousComments = state.comments;
    final previousReplies = state.replies;

    final isTopLevel = state.comments.any((c) => c.id == event.commentId);

    if (isTopLevel) {
      emit(
        state.copyWith(
          comments: state.comments
              .where((c) => c.id != event.commentId)
              .toList(),
        ),
      );
    } else {
      final updatedReplies = <String, List<CommentEntity>>{};
      for (final entry in state.replies.entries) {
        updatedReplies[entry.key] = entry.value
            .where((c) => c.id != event.commentId)
            .toList();
      }
      emit(state.copyWith(replies: updatedReplies));
    }

    final result = await _deleteCommentUsecase(
      DeleteCommentParams(commentId: event.commentId),
    );
    result.fold(
      (_) => emit(
        state.copyWith(comments: previousComments, replies: previousReplies),
      ),
      (_) {},
    );
  }

  Future<void> _onCommentsLoadMore(
    PostDetailCommentsLoadMore event,
    Emitter<PostDetailState> emit,
  ) async {
    final postId = state.post?.id;
    if (!state.hasMoreComments ||
        state.isLoadingMoreComments ||
        postId == null) {
      return;
    }

    emit(state.copyWith(isLoadingMoreComments: true));

    final result = await _getPostCommentsUsecase(
      GetPostCommentsParams(postId: postId, cursor: state.commentsCursor),
    );
    result.fold(
      (_) => emit(state.copyWith(isLoadingMoreComments: false)),
      (paged) => emit(
        state.copyWith(
          isLoadingMoreComments: false,
          comments: [...state.comments, ...paged.items],
          commentsCursor: paged.nextCursor,
          hasMoreComments: paged.hasMore,
        ),
      ),
    );
  }

  Future<void> _onRepliesLoaded(
    PostDetailRepliesLoaded event,
    Emitter<PostDetailState> emit,
  ) async {
    emit(
      state.copyWith(
        loadingReplies: {...state.loadingReplies, event.commentId: true},
      ),
    );

    final result = await _getCommentRepliesUsecase(
      GetCommentRepliesParams(commentId: event.commentId),
    );
    result.fold(
      (_) => emit(
        state.copyWith(
          loadingReplies: {...state.loadingReplies, event.commentId: false},
        ),
      ),
      (paged) => emit(
        state.copyWith(
          loadingReplies: {...state.loadingReplies, event.commentId: false},
          replies: {...state.replies, event.commentId: paged.items},
        ),
      ),
    );
  }

  void _onReplyingSet(
    PostDetailReplyingSet event,
    Emitter<PostDetailState> emit,
  ) {
    emit(
      state.copyWith(
        replyingToCommentId: event.commentId,
        replyingToAuthorName: event.authorName,
      ),
    );
  }

  void _onReplyCancelled(
    PostDetailReplyCancelled event,
    Emitter<PostDetailState> emit,
  ) {
    emit(state.copyWith(replyingToCommentId: null, replyingToAuthorName: null));
  }

  void _onPostEdited(
    PostDetailPostEdited event,
    Emitter<PostDetailState> emit,
  ) {
    emit(state.copyWith(post: event.updatedPost));
  }
}

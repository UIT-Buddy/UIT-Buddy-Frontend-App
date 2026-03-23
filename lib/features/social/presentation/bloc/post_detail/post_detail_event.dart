import 'package:equatable/equatable.dart';
import 'package:uit_buddy_mobile/features/social/domain/entities/post_entity.dart';

abstract class PostDetailEvent extends Equatable {
  const PostDetailEvent();

  @override
  List<Object?> get props => [];
}

class PostDetailStarted extends PostDetailEvent {
  final String postId;
  final PostEntity? initialPost;

  const PostDetailStarted({required this.postId, this.initialPost});

  @override
  List<Object?> get props => [postId];
}

class PostDetailPostLikeToggled extends PostDetailEvent {
  const PostDetailPostLikeToggled();
}

class PostDetailCommentSubmitted extends PostDetailEvent {
  final String content;

  const PostDetailCommentSubmitted({required this.content});

  @override
  List<Object?> get props => [content];
}

class PostDetailReplySubmitted extends PostDetailEvent {
  final String commentId;
  final String content;

  const PostDetailReplySubmitted({
    required this.commentId,
    required this.content,
  });

  @override
  List<Object?> get props => [commentId, content];
}

class PostDetailCommentLikeToggled extends PostDetailEvent {
  final String commentId;

  const PostDetailCommentLikeToggled({required this.commentId});

  @override
  List<Object?> get props => [commentId];
}

class PostDetailCommentDeleted extends PostDetailEvent {
  final String commentId;

  const PostDetailCommentDeleted({required this.commentId});

  @override
  List<Object?> get props => [commentId];
}

class PostDetailCommentsLoadMore extends PostDetailEvent {
  const PostDetailCommentsLoadMore();
}

class PostDetailRepliesLoaded extends PostDetailEvent {
  final String commentId;

  const PostDetailRepliesLoaded({required this.commentId});

  @override
  List<Object?> get props => [commentId];
}

class PostDetailReplyingSet extends PostDetailEvent {
  final String commentId;
  final String authorName;

  const PostDetailReplyingSet({
    required this.commentId,
    required this.authorName,
  });

  @override
  List<Object?> get props => [commentId, authorName];
}

class PostDetailReplyCancelled extends PostDetailEvent {
  const PostDetailReplyCancelled();
}

class PostDetailPostEdited extends PostDetailEvent {
  final PostEntity updatedPost;

  const PostDetailPostEdited({required this.updatedPost});

  @override
  List<Object?> get props => [updatedPost.id];
}

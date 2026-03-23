import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:uit_buddy_mobile/features/social/domain/entities/comment_entity.dart';
import 'package:uit_buddy_mobile/features/social/domain/entities/post_entity.dart';

part 'post_detail_state.freezed.dart';

@freezed
abstract class PostDetailState with _$PostDetailState {
  const factory PostDetailState({
    @Default(false) bool isPostLoading,
    @Default(false) bool isCommentsLoading,
    PostEntity? post,
    @Default([]) List<CommentEntity> comments,
    @Default({}) Map<String, List<CommentEntity>> replies,
    @Default({}) Map<String, bool> loadingReplies,
    String? commentsCursor,
    @Default(true) bool hasMoreComments,
    @Default(false) bool isLoadingMoreComments,
    @Default(false) bool isSubmittingComment,
    String? replyingToCommentId,
    String? replyingToAuthorName,
    String? errorMessage,
    String? submitCommentError,
  }) = _PostDetailState;
}

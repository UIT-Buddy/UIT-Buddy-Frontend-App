abstract interface class ReactionDatasourceInterface {
  Future<void> togglePostLike(String postId);

  Future<void> toggleCommentLike(String commentId);
}

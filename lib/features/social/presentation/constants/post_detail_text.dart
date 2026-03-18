class PostDetailText {
  // Screen
  static const String screenTitle = 'Post Details';
  static const String retry = 'Retry';
  static const String errorLoadingPost = 'Unable to load the post.';
  static const String genericError = 'Something went wrong. Please try again later.';

  // Comments section
  static String commentsHeader(int count) => 'Comments ($count)';
  static const String noComments = 'No comments yet. Be the first to comment!';
  static const String allCommentsShown = 'All comments are displayed';

  // Comment item
  static const String anonymous = 'Anonymous';
  static const String like = 'Like';
  static const String reply = 'Reply';
  static String viewReplies(int count) => 'View $count replies';

  // Comment menu
  static const String copy = 'Copy';
  static const String report = 'Report';
  static const String deleteComment = 'Delete comment';
  static const String copiedToClipboard = 'Content copied to clipboard';
  static const String reportSent = 'Report sent';

  // Delete dialog
  static const String deleteCommentTitle = 'Delete Comment';
  static const String deleteCommentBody =
      'This comment will be permanently deleted. Are you sure?';
  static const String cancel = 'Cancel';
  static const String delete = 'Delete';

  // Input bar
  static const String writeComment = 'Write a comment...';
  static const String replyToComment = 'Write a reply...';
  static String replyingTo(String name) => 'Replying to $name';
}
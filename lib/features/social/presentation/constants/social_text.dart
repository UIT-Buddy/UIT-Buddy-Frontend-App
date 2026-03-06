class SocialText {
  // Header
  static const String title = 'Social';
  static const String feedTab = 'Feed';
  static const String messageTab = 'Message';

  // Create Post
  static const String createPostHint = "What's on your mind?";
  static const String createPostTitle = 'Create Post';
  static const String post = 'Post';
  static const String publicVisibility = 'Public';

  // Post Actions
  static const String like = 'Like';
  static const String comment = 'Comment';
  static const String share = 'Share';

  // Stats
  static String likesCount(int count) => '$count likes';
  static String commentsCount(int count) => '$count comments';
  static String sharesCount(int count) => '$count shares';

  // States
  static const String loading = 'Loading...';
  static const String noPostsYet = 'No posts yet';
  static const String errorLoading = 'Failed to load posts';
  static const String messagePlaceholder = 'Messages coming soon...';
}

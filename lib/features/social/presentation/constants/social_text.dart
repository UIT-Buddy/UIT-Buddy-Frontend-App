class SocialText {
  // Header
  static const String title = 'Social';
  static const String feedTab = 'Feed';
  static const String messageTab = 'Message';
  static const String searchTitle = 'Search';
  static const String searchHint = 'Search users or posts';
  static const String searchFeedHint = 'Search posts and friends';
  static const String searchMessageHint = 'Search messages';
  static const String searchTabAll = 'All';
  static const String searchTabUsers = 'Users';
  static const String searchTabPosts = 'Posts';
  static const String searchNoUsers = 'No users found';
  static const String searchNoPosts = 'No posts found';
  static const String searchEmptySubtitle =
      'Try a different keyword or make it a bit more specific.';
  static String searchEmptyTitle(String query) => 'No results for "$query"';
  static const String retry = 'Retry';
  static const String searchStartPrompt =
      'Type a keyword to search posts and friends.';
  static const String messageSearchComingSoon = 'Message search coming soon';
  static const String messageSearchComingSoonSubtitle =
      'The message search screen is ready, but backend/search flow for conversations is not implemented yet.';

  // Create Post
  static const String createPostHint = "What's on your mind?";
  static const String createPostTitleHint = "Enter your post title";
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

  // Edit Post screen
  static const String editPostTitle = 'Edit post';
  static const String save = 'Save';
  static const String genericError =
      'An error occurred. Please try again later.';

  // Post menu — actions
  static const String copyPostContent = 'Copy content';
  static const String savePost = 'Save post';
  static const String editPost = 'Edit post';
  static const String deletePost = 'Delete post';
  static const String hidePost = 'Hide post';
  static const String reportPost = 'Report post';

  // Post menu — feedback snackbars
  static const String postContentCopied = 'Content copied';
  static const String postSaved = 'Post saved';
  static const String postHidden = 'Post hidden';
  static const String postReported = 'Report submitted';

  // Delete post dialog
  static const String deletePostTitle = 'Delete post';
  static const String deletePostBody =
      'This post will be permanently deleted and cannot be recovered. Are you sure you want to delete it?';
  static const String cancel = 'Cancel';
  static const String delete = 'Delete';
}

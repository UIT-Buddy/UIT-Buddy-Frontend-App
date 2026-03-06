class PostEntity {
  final String id;
  final String authorName;
  final String authorClass;
  final String authorAvatarUrl;
  final String content;
  final String? imageUrl;
  final String timeAgo;
  final int likeCount;
  final int commentCount;
  final int shareCount;
  final bool isLiked;

  const PostEntity({
    required this.id,
    required this.authorName,
    required this.authorClass,
    required this.authorAvatarUrl,
    required this.content,
    this.imageUrl,
    required this.timeAgo,
    required this.likeCount,
    required this.commentCount,
    required this.shareCount,
    this.isLiked = false,
  });

  PostEntity copyWith({
    String? id,
    String? authorName,
    String? authorClass,
    String? authorAvatarUrl,
    String? content,
    String? imageUrl,
    String? timeAgo,
    int? likeCount,
    int? commentCount,
    int? shareCount,
    bool? isLiked,
  }) {
    return PostEntity(
      id: id ?? this.id,
      authorName: authorName ?? this.authorName,
      authorClass: authorClass ?? this.authorClass,
      authorAvatarUrl: authorAvatarUrl ?? this.authorAvatarUrl,
      content: content ?? this.content,
      imageUrl: imageUrl ?? this.imageUrl,
      timeAgo: timeAgo ?? this.timeAgo,
      likeCount: likeCount ?? this.likeCount,
      commentCount: commentCount ?? this.commentCount,
      shareCount: shareCount ?? this.shareCount,
      isLiked: isLiked ?? this.isLiked,
    );
  }
}

import 'package:uit_buddy_mobile/features/social/domain/entities/post_media_entity.dart';

class PostEntity {
  final String id;
  final String title;
  final String authorMssv;
  final String authorName;
  final String authorClass;
  final String? authorAvatarUrl;
  final String contentSnippet;
  final List<PostMediaEntity> medias;
  final DateTime createdAt;
  final int likeCount;
  final int commentCount;
  final int shareCount;
  final bool isLiked;
  final bool isShared;

  const PostEntity({
    required this.id,
    required this.title,
    required this.authorMssv,
    required this.authorName,
    required this.authorClass,
    this.authorAvatarUrl,
    required this.contentSnippet,
    this.medias = const [],
    required this.createdAt,
    required this.likeCount,
    required this.commentCount,
    required this.shareCount,
    this.isLiked = false,
    this.isShared = false,
  });

  PostEntity copyWith({
    String? id,
    String? title,
    String? authorMssv,
    String? authorName,
    String? authorClass,
    String? authorAvatarUrl,
    String? contentSnippet,
    List<PostMediaEntity>? medias,
    DateTime? createdAt,
    int? likeCount,
    int? commentCount,
    int? shareCount,
    bool? isLiked,
    bool? isShared,
  }) {
    return PostEntity(
      id: id ?? this.id,
      title: title ?? this.title,
      authorMssv: authorMssv ?? this.authorMssv,
      authorName: authorName ?? this.authorName,
      authorClass: authorClass ?? this.authorClass,
      authorAvatarUrl: authorAvatarUrl ?? this.authorAvatarUrl,
      contentSnippet: contentSnippet ?? this.contentSnippet,
      medias: medias ?? this.medias,
      createdAt: createdAt ?? this.createdAt,
      likeCount: likeCount ?? this.likeCount,
      commentCount: commentCount ?? this.commentCount,
      shareCount: shareCount ?? this.shareCount,
      isLiked: isLiked ?? this.isLiked,
      isShared: isShared ?? this.isShared,
    );
  }
}

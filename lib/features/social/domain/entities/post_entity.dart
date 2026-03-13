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

   String get timeAgo {
    final diff = DateTime.now().difference(createdAt);

    if (diff.inSeconds < 60) {
      return '${diff.inSeconds}s ago';
    } else if (diff.inMinutes < 60) {
      return '${diff.inMinutes}m ago';
    } else if (diff.inHours < 24) {
      return '${diff.inHours}h ago';
    } else if (diff.inDays < 7) {
      return '${diff.inDays}d ago';
    } else {
      final weeks = (diff.inDays / 7).floor();
      if (weeks < 4) {
        return '${weeks}w ago';
      } else {
        final months = (diff.inDays / 30).floor();
        if (months < 12) {
          return '${months}mo ago';
        } else {
          final years = (diff.inDays / 365).floor();
          return '${years}y ago';
        }
      }
    }
  }
}

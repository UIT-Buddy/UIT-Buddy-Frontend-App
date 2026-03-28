import 'package:equatable/equatable.dart';

enum MediaType { image, video }

class PostEntity extends Equatable {
  final String id;
  final String title;
  final String content;
  final List<MediaEntity> medias;
  final AuthorEntity author;
  final int likeCount;
  final int commentCount;
  final int shareCount;
  final bool isLiked;
  final bool isShared;
  final DateTime createdAt;

  const PostEntity({
    required this.id,
    required this.title,
    required this.content,
    required this.medias,
    required this.author,
    required this.likeCount,
    required this.commentCount,
    required this.shareCount,
    required this.isLiked,
    required this.isShared,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [
    id,
    title,
    content,
    medias,
    likeCount,
    commentCount,
    shareCount,
    isLiked,
    isShared,
    createdAt,
  ];

  PostEntity copyWith({
    String? id,
    String? title,
    String? content,
    List<MediaEntity>? medias,
    AuthorEntity? author,
    int? likeCount,
    int? commentCount,
    int? shareCount,
    bool? isLiked,
    bool? isShared,
    DateTime? createdAt,
  }) {
    return PostEntity(
      id: id ?? this.id,
      title: title ?? this.title,
      content: content ?? this.content,
      medias: medias ?? this.medias,
      author: author ?? this.author,
      likeCount: likeCount ?? this.likeCount,
      commentCount: commentCount ?? this.commentCount,
      shareCount: shareCount ?? this.shareCount,
      isLiked: isLiked ?? this.isLiked,
      isShared: isShared ?? this.isShared,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

class AuthorEntity extends Equatable {
  final String mssv;
  final String fullName;
  final String avatarUrl;
  final String homeClassCode;

  const AuthorEntity({
    required this.mssv,
    required this.fullName,
    required this.avatarUrl,
    required this.homeClassCode,
  });

  @override
  List<Object?> get props => [mssv, fullName, avatarUrl, homeClassCode];
}

class MediaEntity extends Equatable {
  final MediaType type;
  final String url;

  const MediaEntity({required this.type, required this.url});

  @override
  List<Object?> get props => [type, url];
}

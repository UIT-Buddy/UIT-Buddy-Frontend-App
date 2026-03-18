import 'package:uit_buddy_mobile/features/social/data/models/post_media_model.dart';
import 'package:uit_buddy_mobile/features/social/data/models/post_model.dart';
import 'package:uit_buddy_mobile/features/social/domain/entities/post_entity.dart';
import 'package:uit_buddy_mobile/features/social/domain/entities/post_media_entity.dart';

extension PostModelMapper on PostModel {
  PostEntity toEntity() => PostEntity(
    id: id,
    title: title,
    authorMssv: author.mssv,
    authorName: author.fullName,
    authorClass: author.homeClassCode,
    authorAvatarUrl: author.avatarUrl,
    contentSnippet: content ?? contentSnippet ?? "",
    medias: medias.map((m) => m.toEntity()).toList(),
    createdAt: createdAt,
    likeCount: likeCount,
    commentCount: commentCount,
    shareCount: shareCount,
    isLiked: isLiked,
    isShared: isShared,
  );
}

extension PostMediaModelMapper on PostMediaModel {
  PostMediaEntity toEntity() => PostMediaEntity(
    type: type.toUpperCase() == 'VIDEO'
        ? PostMediaType.video
        : PostMediaType.image,
    url: url,
  );
}

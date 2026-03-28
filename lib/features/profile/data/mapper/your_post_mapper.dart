import 'package:uit_buddy_mobile/features/profile/data/models/your_post_author_model.dart';
import 'package:uit_buddy_mobile/features/profile/data/models/your_post_media_model.dart';
import 'package:uit_buddy_mobile/features/profile/data/models/your_post_model.dart';
import 'package:uit_buddy_mobile/features/profile/domain/entities/post_entity.dart';

extension YourPostModelMapper on YourPostModel {
  PostEntity toEntity() => PostEntity(
    id: id,
    title: title,
    content: contentSnippet ?? "",
    author: author.toEntity(),
    medias: medias.map((m) => m.toEntity()).toList(),
    likeCount: likeCount,
    commentCount: commentCount,
    shareCount: shareCount,
    isLiked: isLiked,
    isShared: isShared,
    createdAt: createdAt
  );
}

extension YourPostAuthorMapper on YourPostAuthorModel {
  AuthorEntity toEntity() => AuthorEntity(
    mssv: mssv,
    fullName: fullName,
    avatarUrl: avatarUrl ?? '',
    homeClassCode: homeClassCode
  );
}

extension YourPostMediaMapper on YourPostMediaModel {
  MediaEntity toEntity() => MediaEntity(
    type: type.toUpperCase() == 'VIDEO' ? MediaType.video : MediaType.image,
    url: url,
  );
}
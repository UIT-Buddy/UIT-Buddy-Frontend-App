import 'package:uit_buddy_mobile/features/profile/data/models/post_model.dart'
    as model;
import 'package:uit_buddy_mobile/features/profile/domain/entities/post_entity.dart'
    as entity;

extension PostModelMapper on model.PostModel {
  entity.PostEntity toEntity() => entity.PostEntity(
        id: id,
        user: entity.UserEntity(
          name: user.name,
          homeClass: user.homeClass,
          avatarUrl: user.avatarUrl,
        ),
        content: content,
        mediaUrls: mediaUrls,
        likeCount: likeCount,
        commentCount: commentCount,
        shareCount: shareCount,
      );
}

import 'package:uit_buddy_mobile/features/social/data/mapper/post_mapper.dart';
import 'package:uit_buddy_mobile/features/social/data/models/search_post_model.dart';
import 'package:uit_buddy_mobile/features/social/domain/entities/post_entity.dart';

extension SearchPostModelMapper on SearchPostModel {
  PostEntity toEntity() => PostEntity(
    id: id,
    title: title,
    authorMssv: author?.mssv ?? '',
    authorName: author?.fullName ?? 'Unknown user',
    authorClass: author?.homeClassCode ?? 'UIT',
    authorAvatarUrl: author?.avatarUrl,
    contentSnippet: contentSnippet,
    medias: medias.map((media) => media.toEntity()).toList(),
    createdAt: createdAt,
    likeCount: likeCount,
    commentCount: commentCount,
    shareCount: shareCount,
    isLiked: isLiked,
    isShared: false,
  );
}

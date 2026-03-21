import 'package:uit_buddy_mobile/features/social/data/models/comment_author_model.dart';
import 'package:uit_buddy_mobile/features/social/data/models/comment_model.dart';
import 'package:uit_buddy_mobile/features/social/domain/entities/comment_entity.dart';

extension CommentModelMapper on CommentModel {
  CommentEntity toEntity() => CommentEntity(
    id: id,
    content: content,
    author: user?.toEntity(),
    likeCount: likeCount,
    replyCount: replyCount,
    isLiked: isLiked,
    createdAt: createdAt,
    updatedAt: updatedAt,
    parentId: parentId,
  );
}

extension CommentAuthorModelMapper on CommentAuthorModel {
  CommentAuthorEntity toEntity() =>
      CommentAuthorEntity(mssv: mssv, fullName: fullName, avatarUrl: avatarUrl);
}

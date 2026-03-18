import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:uit_buddy_mobile/features/social/data/models/comment_author_model.dart';

part 'comment_model.freezed.dart';
part 'comment_model.g.dart';

@freezed
abstract class CommentModel with _$CommentModel {
  const factory CommentModel({
    required String id,
    required String content,
    CommentAuthorModel? user,
    required int likeCount,
    required int replyCount,
    @Default(false) bool isLiked,
    required DateTime createdAt,
    required DateTime updatedAt,
    String? parentId,
  }) = _CommentModel;

  factory CommentModel.fromJson(Map<String, dynamic> json) =>
      _$CommentModelFromJson(json);
}

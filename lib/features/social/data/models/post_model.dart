import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:uit_buddy_mobile/features/social/data/models/post_author_model.dart';
import 'package:uit_buddy_mobile/features/social/data/models/post_media_model.dart';

part 'post_model.freezed.dart';
part 'post_model.g.dart';

@freezed
abstract class PostModel with _$PostModel {
  const factory PostModel({
    required String id,
    required String title,
    required String? content,
    required String? contentSnippet,
    @Default([]) List<PostMediaModel> medias,
    required PostAuthorModel author,
    required int likeCount,
    required int commentCount,
    required int shareCount,
    @Default(false) bool isLiked,
    @Default(false) bool isShared,
    required DateTime createdAt,
  }) = _PostModel;

  factory PostModel.fromJson(Map<String, dynamic> json) =>
      _$PostModelFromJson(json);
}

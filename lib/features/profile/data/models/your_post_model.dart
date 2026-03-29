import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:uit_buddy_mobile/features/profile/data/models/your_post_author_model.dart';
import 'package:uit_buddy_mobile/features/profile/data/models/your_post_media_model.dart';

part 'your_post_model.freezed.dart';
part 'your_post_model.g.dart';

@freezed
abstract class YourPostModel with _$YourPostModel {
  const factory YourPostModel({
    required String id,
    required String title,
    required String? contentSnippet,
    @Default([]) List<YourPostMediaModel> medias,
    required YourPostAuthorModel author,
    required int likeCount,
    required int commentCount,
    required int shareCount,
    @Default(false) bool isLiked,
    @Default(false) bool isShared,
    required DateTime createdAt,
  }) = _YourPostModel;

  factory YourPostModel.fromJson(Map<String, dynamic> json) =>
      _$YourPostModelFromJson(json);
}

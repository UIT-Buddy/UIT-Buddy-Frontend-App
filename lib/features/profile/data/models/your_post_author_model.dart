import 'package:freezed_annotation/freezed_annotation.dart';

part 'your_post_author_model.freezed.dart';
part 'your_post_author_model.g.dart';

@freezed
abstract class YourPostAuthorModel with _$YourPostAuthorModel {
  const factory YourPostAuthorModel({
    required String mssv,
    required String fullName,
    String? avatarUrl,
    required String homeClassCode,
  }) = _YourPostAuthorModel;

  factory YourPostAuthorModel.fromJson(Map<String, dynamic> json) =>
      _$YourPostAuthorModelFromJson(json);
}

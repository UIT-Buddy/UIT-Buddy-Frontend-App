import 'package:freezed_annotation/freezed_annotation.dart';

part 'post_author_model.freezed.dart';
part 'post_author_model.g.dart';

@freezed
abstract class PostAuthorModel with _$PostAuthorModel {
  const factory PostAuthorModel({
    required String mssv,
    required String fullName,
    String? avatarUrl,
    required String homeClassCode,
  }) = _PostAuthorModel;

  factory PostAuthorModel.fromJson(Map<String, dynamic> json) =>
      _$PostAuthorModelFromJson(json);
}

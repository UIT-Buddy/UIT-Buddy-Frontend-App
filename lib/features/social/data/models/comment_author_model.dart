import 'package:freezed_annotation/freezed_annotation.dart';

part 'comment_author_model.freezed.dart';
part 'comment_author_model.g.dart';

@freezed
abstract class CommentAuthorModel with _$CommentAuthorModel {
  const factory CommentAuthorModel({
    required String mssv,
    required String fullName,
    String? avatarUrl,
  }) = _CommentAuthorModel;

  factory CommentAuthorModel.fromJson(Map<String, dynamic> json) =>
      _$CommentAuthorModelFromJson(json);
}

import 'package:freezed_annotation/freezed_annotation.dart';

part 'moodle_token_model.freezed.dart';
part 'moodle_token_model.g.dart';

@Freezed()
abstract class MoodleTokenModel with _$MoodleTokenModel {
  const factory MoodleTokenModel({
    required String signupToken,
    required String mssv,
    required String fullName,
  }) = _MoodleTokenModel;

  factory MoodleTokenModel.fromJson(Map<String, dynamic> json) =>
      _$MoodleTokenModelFromJson(json);
}

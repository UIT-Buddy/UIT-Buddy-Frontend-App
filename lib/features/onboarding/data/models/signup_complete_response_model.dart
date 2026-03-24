import 'package:freezed_annotation/freezed_annotation.dart';

part 'signup_complete_response_model.freezed.dart';
part 'signup_complete_response_model.g.dart';

@freezed
abstract class SignUpCompleteUserModel with _$SignUpCompleteUserModel {
  const factory SignUpCompleteUserModel({
    required String mssv,
    required String fullName,
    required String email,
    String? avatarUrl,
  }) = _SignUpCompleteUserModel;

  factory SignUpCompleteUserModel.fromJson(Map<String, dynamic> json) =>
      _$SignUpCompleteUserModelFromJson(json);
}


@freezed
abstract class SignUpCompleteResponseModel with _$SignUpCompleteResponseModel {
  const factory SignUpCompleteResponseModel({
    required String accessToken,
    required String refreshToken,
    required SignUpCompleteUserModel user,
    required String cometAuthToken,
    String? avatarUrl,
  }) = _SignUpCompleteResponseModel;

  factory SignUpCompleteResponseModel.fromJson(Map<String, dynamic> json) =>
      _$SignUpCompleteResponseModelFromJson(json);
}

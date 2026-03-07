import 'package:freezed_annotation/freezed_annotation.dart';

part 'signup_complete_request_model.freezed.dart';
part 'signup_complete_request_model.g.dart';

@freezed
abstract class SignUpCompleteRequestModel with _$SignUpCompleteRequestModel {
  const factory SignUpCompleteRequestModel({
    required String signupToken,
    required String mssv,
    required String password,
    required String confirmPassword,
    @Default('') String fcmToken,
  }) = _SignUpCompleteRequestModel;

  factory SignUpCompleteRequestModel.fromJson(Map<String, dynamic> json) =>
      _$SignUpCompleteRequestModelFromJson(json);
}

import 'package:freezed_annotation/freezed_annotation.dart';

part 'reset_password_request_model.freezed.dart';
part 'reset_password_request_model.g.dart';

@freezed
abstract class ResetPasswordRequestModel with _$ResetPasswordRequestModel {
  const factory ResetPasswordRequestModel({
    required String mssv,
    required String otpCode,
    required String newPassword,
    required String confirmPassword,
  }) = _ResetPasswordRequestModel;

  factory ResetPasswordRequestModel.fromJson(Map<String, dynamic> json) =>
      _$ResetPasswordRequestModelFromJson(json);
}

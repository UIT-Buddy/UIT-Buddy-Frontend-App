import 'package:freezed_annotation/freezed_annotation.dart';

part 'signin_request_model.freezed.dart';
part 'signin_request_model.g.dart';

@freezed
abstract class SignInRequestModel with _$SignInRequestModel {
  const factory SignInRequestModel({
    required String mssv,
    required String password,
    @Default(false) bool rememberMe,
    @Default('') String fcmToken,
  }) = _SignInRequestModel;

  factory SignInRequestModel.fromJson(Map<String, dynamic> json) =>
      _$SignInRequestModelFromJson(json);
}

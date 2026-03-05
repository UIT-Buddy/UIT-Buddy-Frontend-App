import 'package:freezed_annotation/freezed_annotation.dart';

part 'forget_password_request_model.freezed.dart';
part 'forget_password_request_model.g.dart';

@freezed
abstract class ForgetPasswordRequestModel with _$ForgetPasswordRequestModel {
  const factory ForgetPasswordRequestModel({required String mssv}) =
      _ForgetPasswordRequestModel;

  factory ForgetPasswordRequestModel.fromJson(Map<String, dynamic> json) =>
      _$ForgetPasswordRequestModelFromJson(json);
}

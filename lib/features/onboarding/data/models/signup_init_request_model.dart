import 'package:freezed_annotation/freezed_annotation.dart';

part 'signup_init_request_model.freezed.dart';
part 'signup_init_request_model.g.dart';

@freezed
abstract class SignUpInitRequestModel with _$SignUpInitRequestModel {
  const factory SignUpInitRequestModel({required String wstoken}) =
      _SignUpInitRequestModel;

  factory SignUpInitRequestModel.fromJson(Map<String, dynamic> json) =>
      _$SignUpInitRequestModelFromJson(json);
}

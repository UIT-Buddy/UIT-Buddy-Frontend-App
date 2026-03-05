import 'package:freezed_annotation/freezed_annotation.dart';

part 'sign_up_info_state.freezed.dart';

enum SignUpInfoStatus { initial, loading, success, failure }

@freezed
abstract class SignUpInfoState with _$SignUpInfoState {
  const factory SignUpInfoState({
    @Default(SignUpInfoStatus.initial) SignUpInfoStatus status,
    String? errorMessage,
  }) = _SignUpInfoState;
}

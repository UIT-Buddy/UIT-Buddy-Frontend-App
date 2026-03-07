import 'package:freezed_annotation/freezed_annotation.dart';

part 'sign_in_state.freezed.dart';

enum SignInStatus { initial, loading, success, failure }

@freezed
abstract class SignInState with _$SignInState {
  const factory SignInState({
    @Default(SignInStatus.initial) SignInStatus status,
    String? errorMessage,
  }) = _SignInState;
}

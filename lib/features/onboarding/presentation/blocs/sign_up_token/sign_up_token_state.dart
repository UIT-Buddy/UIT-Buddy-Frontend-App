import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:uit_buddy_mobile/features/onboarding/domain/entities/signup_init_entity.dart';

part 'sign_up_token_state.freezed.dart';

enum SignUpTokenStatus { initial, loading, success, failure }

@freezed
abstract class SignUpTokenState with _$SignUpTokenState {
  const factory SignUpTokenState({
    @Default(SignUpTokenStatus.initial) SignUpTokenStatus status,
    @Default(null) SignUpInitEntity? entity,
    String? errorMessage,
  }) = _SignUpTokenState;
}

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:uit_buddy_mobile/features/session/domain/entities/user_entity.dart';

part 'session_state.freezed.dart';

enum SessionStatus { initial, loading, authenticated, unauthenticated, failure }

@freezed
abstract class SessionState with _$SessionState {
  const factory SessionState({
    @Default(SessionStatus.initial) SessionStatus status,
    UserEntity? user,
    String? errorMessage,
  }) = _SessionState;
}

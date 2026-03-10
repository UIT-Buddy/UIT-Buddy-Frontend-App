import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uit_buddy_mobile/core/usecase/usecase_interface.dart';
import 'package:uit_buddy_mobile/features/session/domain/usecases/get_current_user_usecase.dart';
import 'package:uit_buddy_mobile/features/session/presentation/bloc/session_event.dart';
import 'package:uit_buddy_mobile/features/session/presentation/bloc/session_state.dart';

class SessionBloc extends Bloc<SessionEvent, SessionState> {
  SessionBloc({required GetCurrentUserUsecase getCurrentUserUsecase})
    : _getCurrentUserUsecase = getCurrentUserUsecase,
      super(const SessionState()) {
    on<SessionUserFetchRequested>(_onUserFetchRequested);
    on<SessionCleared>(_onSessionCleared);
  }

  final GetCurrentUserUsecase _getCurrentUserUsecase;

  Future<void> _onUserFetchRequested(
    SessionUserFetchRequested event,
    Emitter<SessionState> emit,
  ) async {
    emit(state.copyWith(status: SessionStatus.loading));
    final result = await _getCurrentUserUsecase(const NoParams());
    debugPrint('result: ${result.fold((l) => l.toString(), (r) => r)}');
    result.fold(
      (failure) => emit(
        state.copyWith(
          status: SessionStatus.unauthenticated,
          errorMessage: failure.message,
        ),
      ),
      (user) => emit(
        state.copyWith(
          status: SessionStatus.authenticated,
          user: user,
          errorMessage: null,
        ),
      ),
    );
  }

  void _onSessionCleared(SessionCleared event, Emitter<SessionState> emit) {
    emit(const SessionState(status: SessionStatus.unauthenticated));
  }
}

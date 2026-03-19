import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uit_buddy_mobile/core/usecase/usecase_interface.dart';
import 'package:uit_buddy_mobile/features/profile/domain/usecases/delete_account_usecase.dart';
import 'package:uit_buddy_mobile/features/profile/presentation/bloc/settings_screen/settings_event.dart';
import 'package:uit_buddy_mobile/features/profile/presentation/bloc/settings_screen/settings_state.dart';

class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  SettingsBloc({required DeleteAccountUsecase deleteAccountUsecase})
    : _deleteAccountUsecase = deleteAccountUsecase,
      super(const SettingsState()) {
    on<SettingsStarted>(_onSettingsStarted);
    on<DeleteAccountRequested>(_onDeleteAccountRequested);
  }

  final DeleteAccountUsecase _deleteAccountUsecase;

  void _onSettingsStarted(SettingsStarted event, Emitter<SettingsState> emit) {
    emit(state.copyWith(status: SettingsStatus.loaded));
  }

  Future<void> _onDeleteAccountRequested(
    DeleteAccountRequested event,
    Emitter<SettingsState> emit,
  ) async {
    emit(state.copyWith(status: SettingsStatus.deleting, errorMessage: null));

    final result = await _deleteAccountUsecase(const NoParams());

    result.fold(
      (failure) => emit(
        state.copyWith(
          status: SettingsStatus.error,
          errorMessage: failure.message,
        ),
      ),
      (_) => emit(state.copyWith(status: SettingsStatus.deleted)),
    );
  }
}

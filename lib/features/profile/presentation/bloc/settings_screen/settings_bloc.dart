import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uit_buddy_mobile/core/usecase/usecase_interface.dart';
import 'package:uit_buddy_mobile/features/profile/domain/usecases/change_ws_token_usecase.dart';
import 'package:uit_buddy_mobile/features/profile/domain/usecases/delete_account_usecase.dart';
import 'package:uit_buddy_mobile/features/profile/domain/usecases/get_user_settings_usecase.dart';
import 'package:uit_buddy_mobile/features/profile/domain/usecases/update_user_settings_usecase.dart';
import 'package:uit_buddy_mobile/features/profile/presentation/bloc/settings_screen/settings_event.dart';
import 'package:uit_buddy_mobile/features/profile/presentation/bloc/settings_screen/settings_state.dart';

class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  SettingsBloc({
    required GetUserSettingsUsecase getUserSettingsUsecase,
    required UpdateUserSettingsUsecase updateUserSettingsUsecase,
    required DeleteAccountUsecase deleteAccountUsecase,
    required ChangeWsTokenUsecase changeWsTokenUsecase,
  }) : _getUserSettingsUsecase = getUserSettingsUsecase,
       _updateUserSettingsUsecase = updateUserSettingsUsecase,
       _deleteAccountUsecase = deleteAccountUsecase,
       _changeWsTokenUsecase = changeWsTokenUsecase,
       super(const SettingsState()) {
    on<SettingsStarted>(_onSettingsStarted);
    on<UpdateUserSettingsRequested>(_onUpdateUserSettingsRequested);
    on<DeleteAccountRequested>(_onDeleteAccountRequested);
    on<ChangeWsTokenRequested>(_onChangeWsTokenRequested);
  }

  final GetUserSettingsUsecase _getUserSettingsUsecase;
  final UpdateUserSettingsUsecase _updateUserSettingsUsecase;
  final DeleteAccountUsecase _deleteAccountUsecase;
  final ChangeWsTokenUsecase _changeWsTokenUsecase;

  Future<void> _onSettingsStarted(
    SettingsStarted event,
    Emitter<SettingsState> emit,
  ) async {
    emit(state.copyWith(status: SettingsStatus.loading, errorMessage: null));

    final result = await _getUserSettingsUsecase(const NoParams());

    result.fold(
      (failure) => emit(
        state.copyWith(
          status: SettingsStatus.error,
          errorMessage: failure.message,
        ),
      ),
      (settings) => emit(
        state.copyWith(
          status: SettingsStatus.loaded,
          enableNotification: settings.enableNotification,
          enableScheduleReminder: settings.enableScheduleReminder,
          errorMessage: null,
        ),
      ),
    );
  }

  Future<void> _onUpdateUserSettingsRequested(
    UpdateUserSettingsRequested event,
    Emitter<SettingsState> emit,
  ) async {
    final previousNotification = state.enableNotification;
    final previousScheduleReminder = state.enableScheduleReminder;

    emit(
      state.copyWith(
        status: SettingsStatus.changingUserSettings,
        enableNotification: event.enableNotification,
        enableScheduleReminder: event.enableScheduleReminder,
        errorMessage: null,
      ),
    );

    final result = await _updateUserSettingsUsecase(
      UpdateUserSettingsParams(
        enableNotification: event.enableNotification,
        enableScheduleReminder: event.enableScheduleReminder,
      ),
    );

    result.fold(
      (failure) => emit(
        state.copyWith(
          status: SettingsStatus.error,
          enableNotification: previousNotification,
          enableScheduleReminder: previousScheduleReminder,
          errorMessage: failure.message,
        ),
      ),
      (settings) => emit(
        state.copyWith(
          status: SettingsStatus.userSettingsUpdated,
          enableNotification: settings.enableNotification,
          enableScheduleReminder: settings.enableScheduleReminder,
          errorMessage: null,
        ),
      ),
    );
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

  Future<void> _onChangeWsTokenRequested(
    ChangeWsTokenRequested event,
    Emitter<SettingsState> emit,
  ) async {
    emit(
      state.copyWith(
        status: SettingsStatus.changingWsToken,
        errorMessage: null,
      ),
    );

    final result = await _changeWsTokenUsecase(event.newToken);

    result.fold(
      (failure) => emit(
        state.copyWith(
          status: SettingsStatus.error,
          errorMessage: failure.message,
        ),
      ),
      (_) => emit(state.copyWith(status: SettingsStatus.wsTokenChanged)),
    );
  }
}

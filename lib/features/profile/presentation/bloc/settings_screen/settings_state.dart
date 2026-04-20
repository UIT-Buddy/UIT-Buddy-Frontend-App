import 'package:equatable/equatable.dart';

enum SettingsStatus {
  initial,
  loading,
  loaded,
  error,
  changingUserSettings,
  userSettingsUpdated,
  deleting,
  deleted,
  changingWsToken,
  wsTokenChanged,
}

class SettingsState extends Equatable {
  const SettingsState({
    this.status = SettingsStatus.initial,
    this.enableNotification = false,
    this.enableScheduleReminder = false,
    this.errorMessage,
  });

  final SettingsStatus status;
  final bool enableNotification;
  final bool enableScheduleReminder;
  final String? errorMessage;

  SettingsState copyWith({
    SettingsStatus? status,
    Object? enableNotification = _noValue,
    Object? enableScheduleReminder = _noValue,
    Object? errorMessage = _noValue,
  }) {
    return SettingsState(
      status: status ?? this.status,
      enableNotification: identical(enableNotification, _noValue)
          ? this.enableNotification
          : enableNotification as bool,
      enableScheduleReminder: identical(enableScheduleReminder, _noValue)
          ? this.enableScheduleReminder
          : enableScheduleReminder as bool,
      errorMessage: identical(errorMessage, _noValue)
          ? this.errorMessage
          : errorMessage as String?,
    );
  }

  @override
  List<Object?> get props => [
    status,
    enableNotification,
    enableScheduleReminder,
    errorMessage,
  ];
}

const _noValue = Object();

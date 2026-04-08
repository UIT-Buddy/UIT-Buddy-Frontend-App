import 'package:equatable/equatable.dart';

enum SettingsStatus { initial, loading, loaded, error, deleting, deleted, changingWsToken, wsTokenChanged }

class SettingsState extends Equatable {
  const SettingsState({
    this.status = SettingsStatus.initial,
    this.errorMessage,
  });

  final SettingsStatus status;
  final String? errorMessage;

  SettingsState copyWith({
    SettingsStatus? status,
    Object? errorMessage = _noValue,
  }) {
    return SettingsState(
      status: status ?? this.status,
      errorMessage: identical(errorMessage, _noValue)
          ? this.errorMessage
          : errorMessage as String?,
    );
  }

  @override
  List<Object?> get props => [status, errorMessage];
}

const _noValue = Object();

import 'package:equatable/equatable.dart';

abstract class SettingsEvent extends Equatable {
  const SettingsEvent();

  @override
  List<Object?> get props => [];
}

class SettingsStarted extends SettingsEvent {
  const SettingsStarted();
}

class DeleteAccountRequested extends SettingsEvent {
  const DeleteAccountRequested();
}

class ChangeWsTokenRequested extends SettingsEvent {
  final String newToken;
  const ChangeWsTokenRequested({required this.newToken});

    @override
  List<Object?> get props => [newToken];
}

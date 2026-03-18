import 'package:equatable/equatable.dart';

abstract class SessionEvent extends Equatable {
  const SessionEvent();

  @override
  List<Object?> get props => [];
}

/// Dispatched after sign-in or on app start to load the current user.
class SessionUserFetchRequested extends SessionEvent {
  const SessionUserFetchRequested();
}

/// Dispatched on sign-out to clear the current user.
class SessionCleared extends SessionEvent {
  const SessionCleared();
}

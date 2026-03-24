import 'package:equatable/equatable.dart';

abstract class UserProfileEvent extends Equatable {
  const UserProfileEvent();

  @override
  List<Object?> get props => [];
}

class UserProfileStarted extends UserProfileEvent {
  const UserProfileStarted({required this.mssv});

  final String mssv;

  @override
  List<Object?> get props => [mssv];
}

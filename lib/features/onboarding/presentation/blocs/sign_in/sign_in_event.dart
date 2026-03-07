import 'package:equatable/equatable.dart';

abstract class SignInEvent extends Equatable {
  const SignInEvent();

  @override
  List<Object?> get props => [];
}

class SignInPressed extends SignInEvent {
  const SignInPressed({
    required this.mssv,
    required this.password,
    required this.rememberMe,
  });

  final String mssv;
  final String password;
  final bool rememberMe;

  @override
  List<Object?> get props => [mssv, password, rememberMe];
}

import 'package:equatable/equatable.dart';

abstract class SignUpTokenEvent extends Equatable {
  const SignUpTokenEvent();

  @override
  List<Object?> get props => [];
}

class SignUpTokenVerifyPressed extends SignUpTokenEvent {
  const SignUpTokenVerifyPressed({required this.wstoken});

  final String wstoken;

  @override
  List<Object?> get props => [wstoken];
}

class ChangeWsTokenPressed extends SignUpTokenEvent {
  const ChangeWsTokenPressed({
    required this.wstoken,
    required this.mssv,
    required this.password,
  });

  final String wstoken;
  final String mssv;
  final String password;

  @override
  List<Object?> get props => [wstoken, mssv, password];
}

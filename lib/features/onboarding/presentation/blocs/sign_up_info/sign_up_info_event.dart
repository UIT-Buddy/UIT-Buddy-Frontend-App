import 'package:equatable/equatable.dart';

abstract class SignUpInfoEvent extends Equatable {
  const SignUpInfoEvent();

  @override
  List<Object?> get props => [];
}

class SignUpInfoSubmitPressed extends SignUpInfoEvent {
  const SignUpInfoSubmitPressed({
    required this.signupToken,
    required this.mssv,
    required this.password,
    required this.confirmPassword,
  });

  final String signupToken;
  final String mssv;
  final String password;
  final String confirmPassword;

  @override
  List<Object?> get props => [signupToken, mssv, password, confirmPassword];
}

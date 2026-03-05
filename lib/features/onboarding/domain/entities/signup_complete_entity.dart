import 'package:equatable/equatable.dart';

class SignUpCompleteUserEntity extends Equatable {
  const SignUpCompleteUserEntity({
    required this.mssv,
    required this.fullName,
    required this.email,
  });

  final String mssv;
  final String fullName;
  final String email;

  @override
  List<Object?> get props => [mssv, fullName, email];
}

class SignUpCompleteEntity extends Equatable {
  const SignUpCompleteEntity({
    required this.accessToken,
    required this.refreshToken,
    required this.user,
  });

  final String accessToken;
  final String refreshToken;
  final SignUpCompleteUserEntity user;

  @override
  List<Object?> get props => [accessToken, refreshToken, user];
}

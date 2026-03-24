import 'package:equatable/equatable.dart';

class SignUpCompleteUserEntity extends Equatable {
  const SignUpCompleteUserEntity({
    required this.mssv,
    required this.fullName,
    required this.email,
    this.avatarUrl,
  });

  final String mssv;
  final String fullName;
  final String email;
  final String? avatarUrl;
  @override
  List<Object?> get props => [mssv, fullName, email];
}

class SignUpCompleteEntity extends Equatable {
  const SignUpCompleteEntity({
    required this.accessToken,
    required this.refreshToken,
    required this.user,
    required this.cometAuthToken,
    this.avatarUrl,
  });

  final String accessToken;
  final String refreshToken;
  final SignUpCompleteUserEntity user;
  final String cometAuthToken;
  final String? avatarUrl;
  @override
  List<Object?> get props => [accessToken, refreshToken, user];
}

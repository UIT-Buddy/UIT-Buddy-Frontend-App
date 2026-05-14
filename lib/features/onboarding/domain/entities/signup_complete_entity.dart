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
    this.accessToken,
    this.refreshToken,
    this.user,
    this.cometAuthToken,
    this.changeWsToken,
    this.avatarUrl,
  });

  final String? accessToken;
  final String? refreshToken;
  final SignUpCompleteUserEntity? user;
  final String? cometAuthToken;
  final bool? changeWsToken;
  final String? avatarUrl;
  @override
  List<Object?> get props => [accessToken, refreshToken, user, changeWsToken];
}

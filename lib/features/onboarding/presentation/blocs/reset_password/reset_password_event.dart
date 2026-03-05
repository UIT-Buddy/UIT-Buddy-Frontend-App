import 'package:equatable/equatable.dart';

abstract class ResetPasswordEvent extends Equatable {
  const ResetPasswordEvent();

  @override
  List<Object?> get props => [];
}

class ResetPasswordSubmitted extends ResetPasswordEvent {
  const ResetPasswordSubmitted({
    required this.mssv,
    required this.otpCode,
    required this.newPassword,
    required this.confirmPassword,
  });

  final String mssv;
  final String otpCode;
  final String newPassword;
  final String confirmPassword;

  @override
  List<Object?> get props => [mssv, otpCode, newPassword, confirmPassword];
}

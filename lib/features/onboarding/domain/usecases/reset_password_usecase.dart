import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';
import 'package:uit_buddy_mobile/core/error/failures.dart';
import 'package:uit_buddy_mobile/core/usecase/usecase_interface.dart';
import 'package:uit_buddy_mobile/features/onboarding/domain/repositories/auth_repository.dart';

class ResetPasswordUsecase implements UseCase<void, ResetPasswordParams> {
  ResetPasswordUsecase({required AuthRepository authRepository})
    : _authRepository = authRepository;

  final AuthRepository _authRepository;

  @override
  Future<Either<Failure, void>> call(ResetPasswordParams params) =>
      _authRepository.resetPassword(
        mssv: params.mssv,
        otpCode: params.otpCode,
        newPassword: params.newPassword,
        confirmPassword: params.confirmPassword,
      );
}

class ResetPasswordParams extends Equatable {
  const ResetPasswordParams({
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

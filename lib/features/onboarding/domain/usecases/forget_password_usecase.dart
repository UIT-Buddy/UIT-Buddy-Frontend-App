import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';
import 'package:uit_buddy_mobile/core/error/failures.dart';
import 'package:uit_buddy_mobile/core/usecase/usecase_interface.dart';
import 'package:uit_buddy_mobile/features/onboarding/domain/repositories/auth_repository.dart';

class ForgetPasswordUsecase implements UseCase<void, ForgetPasswordParams> {
  ForgetPasswordUsecase({required AuthRepository authRepository})
    : _authRepository = authRepository;

  final AuthRepository _authRepository;

  @override
  Future<Either<Failure, void>> call(ForgetPasswordParams params) =>
      _authRepository.forgetPassword(mssv: params.mssv);
}

class ForgetPasswordParams extends Equatable {
  const ForgetPasswordParams({required this.mssv});

  final String mssv;

  @override
  List<Object?> get props => [mssv];
}

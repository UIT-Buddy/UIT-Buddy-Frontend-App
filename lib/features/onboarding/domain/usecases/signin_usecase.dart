import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';
import 'package:uit_buddy_mobile/core/error/failures.dart';
import 'package:uit_buddy_mobile/core/usecase/usecase_interface.dart';
import 'package:uit_buddy_mobile/features/onboarding/domain/entities/signup_complete_entity.dart';
import 'package:uit_buddy_mobile/features/onboarding/domain/repositories/auth_repository.dart';

class SignInUsecase implements UseCase<SignUpCompleteEntity, SignInParams> {
  SignInUsecase({required AuthRepository authRepository})
    : _authRepository = authRepository;

  final AuthRepository _authRepository;

  @override
  Future<Either<Failure, SignUpCompleteEntity>> call(SignInParams params) =>
      _authRepository.signIn(
        mssv: params.mssv,
        password: params.password,
        rememberMe: params.rememberMe,
        fcmToken: params.fcmToken,
      );
}

class SignInParams extends Equatable {
  const SignInParams({
    required this.mssv,
    required this.password,
    this.rememberMe = false,
    this.fcmToken = '',
  });

  final String mssv;
  final String password;
  final bool rememberMe;
  final String fcmToken;

  @override
  List<Object?> get props => [mssv, password, rememberMe, fcmToken];
}

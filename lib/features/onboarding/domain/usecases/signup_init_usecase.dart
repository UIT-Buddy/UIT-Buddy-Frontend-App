import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';
import 'package:uit_buddy_mobile/core/error/failures.dart';
import 'package:uit_buddy_mobile/core/usecase/usecase_interface.dart';
import 'package:uit_buddy_mobile/features/onboarding/domain/entities/signup_init_entity.dart';
import 'package:uit_buddy_mobile/features/onboarding/domain/repositories/auth_repository.dart';

class SignUpInitUsecase implements UseCase<SignUpInitEntity, SignUpInitParams> {
  SignUpInitUsecase({required AuthRepository authRepository})
    : _authRepository = authRepository;

  final AuthRepository _authRepository;

  @override
  Future<Either<Failure, SignUpInitEntity>> call(SignUpInitParams params) =>
      _authRepository.signUpInit(wstoken: params.wstoken);
}

class SignUpInitParams extends Equatable {
  const SignUpInitParams({required this.wstoken});

  final String wstoken;

  @override
  List<Object?> get props => [wstoken];
}

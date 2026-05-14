import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';
import 'package:uit_buddy_mobile/core/error/failures.dart';
import 'package:uit_buddy_mobile/core/usecase/usecase_interface.dart';
import 'package:uit_buddy_mobile/features/onboarding/domain/entities/signup_complete_entity.dart';
import 'package:uit_buddy_mobile/features/onboarding/domain/repositories/auth_repository.dart';

class ChangeWsTokenParams extends Equatable {
  const ChangeWsTokenParams({
    required this.mssv,
    required this.password,
    required this.wstoken,
  });

  final String mssv;
  final String password;
  final String wstoken;

  @override
  List<Object?> get props => [mssv, password, wstoken];
}

class ChangeWsTokenOnboardingUsecase
    implements UseCase<SignUpCompleteEntity, ChangeWsTokenParams> {
  ChangeWsTokenOnboardingUsecase({required AuthRepository authRepository})
    : _authRepository = authRepository;

  final AuthRepository _authRepository;

  @override
  Future<Either<Failure, SignUpCompleteEntity>> call(
    ChangeWsTokenParams params,
  ) {
    return _authRepository.changeWsToken(
      mssv: params.mssv,
      password: params.password,
      wstoken: params.wstoken,
    );
  }
}

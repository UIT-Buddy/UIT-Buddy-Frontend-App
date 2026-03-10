import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';
import 'package:uit_buddy_mobile/core/error/failures.dart';
import 'package:uit_buddy_mobile/core/usecase/usecase_interface.dart';
import 'package:uit_buddy_mobile/features/onboarding/domain/entities/signup_complete_entity.dart';
import 'package:uit_buddy_mobile/features/onboarding/domain/repositories/auth_repository.dart';
import 'package:uit_buddy_mobile/features/onboarding/domain/repositories/firebase_repository.dart';

class SignInUsecase implements UseCase<SignUpCompleteEntity, SignInParams> {
  SignInUsecase({
    required AuthRepository authRepository,
    required FirebaseRepository firebaseRepository,
  }) : _authRepository = authRepository,
       _firebaseRepository = firebaseRepository;

  final AuthRepository _authRepository;
  final FirebaseRepository _firebaseRepository;

  @override
  Future<Either<Failure, SignUpCompleteEntity>> call(
    SignInParams params,
  ) async {
    final fcmToken = await _firebaseRepository.getFcmToken() ?? '';
    return _authRepository.signIn(
      mssv: params.mssv,
      password: params.password,
      rememberMe: params.rememberMe,
      fcmToken: fcmToken,
    );
  }
}

class SignInParams extends Equatable {
  const SignInParams({
    required this.mssv,
    required this.password,
    this.rememberMe = false,
  });

  final String mssv;
  final String password;
  final bool rememberMe;

  @override
  List<Object?> get props => [mssv, password, rememberMe];
}

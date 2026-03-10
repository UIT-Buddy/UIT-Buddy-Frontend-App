import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';
import 'package:uit_buddy_mobile/core/error/failures.dart';
import 'package:uit_buddy_mobile/core/usecase/usecase_interface.dart';
import 'package:uit_buddy_mobile/features/onboarding/domain/entities/signup_complete_entity.dart';
import 'package:uit_buddy_mobile/features/onboarding/domain/repositories/auth_repository.dart';
import 'package:uit_buddy_mobile/features/onboarding/domain/repositories/firebase_repository.dart';

class SignUpCompleteUsecase
    implements UseCase<SignUpCompleteEntity, SignUpCompleteParams> {
  SignUpCompleteUsecase({
    required AuthRepository authRepository,
    required FirebaseRepository firebaseRepository,
  }) : _authRepository = authRepository,
       _firebaseRepository = firebaseRepository;

  final AuthRepository _authRepository;
  final FirebaseRepository _firebaseRepository;

  @override
  Future<Either<Failure, SignUpCompleteEntity>> call(
    SignUpCompleteParams params,
  ) async {
    final fcmToken = await _firebaseRepository.getFcmToken() ?? '';
    return _authRepository.signUpComplete(
      signupToken: params.signupToken,
      mssv: params.mssv,
      password: params.password,
      confirmPassword: params.confirmPassword,
      fcmToken: fcmToken,
    );
  }
}

class SignUpCompleteParams extends Equatable {
  const SignUpCompleteParams({
    required this.signupToken,
    required this.mssv,
    required this.password,
    required this.confirmPassword,
  });

  final String signupToken;
  final String mssv;
  final String password;
  final String confirmPassword;

  @override
  List<Object?> get props => [signupToken, mssv, password, confirmPassword];
}

import 'package:fpdart/fpdart.dart';
import 'package:uit_buddy_mobile/core/error/failures.dart';
import 'package:uit_buddy_mobile/features/onboarding/domain/entities/signup_complete_entity.dart';
import 'package:uit_buddy_mobile/features/onboarding/domain/entities/signup_init_entity.dart';

abstract interface class AuthRepository {
  Future<Either<Failure, SignUpInitEntity>> signUpInit({
    required String wstoken,
  });

  Future<Either<Failure, SignUpCompleteEntity>> signUpComplete({
    required String signupToken,
    required String mssv,
    required String password,
    required String confirmPassword,
    String fcmToken,
  });

  Future<Either<Failure, SignUpCompleteEntity>> signIn({
    required String mssv,
    required String password,
    bool rememberMe,
    String fcmToken,
  });

  Future<Either<Failure, void>> forgetPassword({required String mssv});

  Future<Either<Failure, void>> resetPassword({
    required String mssv,
    required String otpCode,
    required String newPassword,
    required String confirmPassword,
  });
}

import 'package:mockito/annotations.dart';
import 'package:uit_buddy_mobile/features/onboarding/domain/repositories/auth_repository.dart';
import 'package:uit_buddy_mobile/features/onboarding/domain/repositories/firebase_repository.dart';
import 'package:uit_buddy_mobile/features/onboarding/domain/usecases/forget_password_usecase.dart';
import 'package:uit_buddy_mobile/features/onboarding/domain/usecases/reset_password_usecase.dart';
import 'package:uit_buddy_mobile/features/onboarding/domain/usecases/signin_usecase.dart';

@GenerateMocks([
  AuthRepository,
  FirebaseRepository,
  SignInUsecase,
  ForgetPasswordUsecase,
  ResetPasswordUsecase,
])
void main() {}

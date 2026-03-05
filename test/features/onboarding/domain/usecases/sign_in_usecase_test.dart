import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mockito/mockito.dart';
import 'package:uit_buddy_mobile/core/error/failures.dart';
import 'package:uit_buddy_mobile/features/onboarding/domain/entities/signup_complete_entity.dart';
import 'package:uit_buddy_mobile/features/onboarding/domain/usecases/signin_usecase.dart';

import '../../../../mocks/mocks.mocks.dart';

void main() {
  late MockAuthRepository mockRepository;
  late SignInUsecase usecase;

  const tMssv = '21521234';
  const tPassword = 'password123';
  const tUser = SignUpCompleteUserEntity(
    mssv: tMssv,
    fullName: 'Test User',
    email: 'test@uit.edu.vn',
  );
  const tEntity = SignUpCompleteEntity(
    accessToken: 'access_token',
    refreshToken: 'refresh_token',
    user: tUser,
  );

  setUp(() {
    mockRepository = MockAuthRepository();
    provideDummy<Either<Failure, SignUpCompleteEntity>>(const Right(tEntity));
    usecase = SignInUsecase(authRepository: mockRepository);
  });

  group('SignInUsecase', () {
    test(
      'should return SignUpCompleteEntity when repository succeeds',
      () async {
        when(
          mockRepository.signIn(
            mssv: tMssv,
            password: tPassword,
            rememberMe: false,
            fcmToken: '',
          ),
        ).thenAnswer((_) async => const Right(tEntity));

        final result = await usecase(
          const SignInParams(mssv: tMssv, password: tPassword),
        );

        expect(result, const Right(tEntity));
        verify(
          mockRepository.signIn(
            mssv: tMssv,
            password: tPassword,
            rememberMe: false,
            fcmToken: '',
          ),
        );
        verifyNoMoreInteractions(mockRepository);
      },
    );

    test('should return Failure when repository fails', () async {
      final tFailure = Failure('Invalid credentials');
      when(
        mockRepository.signIn(
          mssv: tMssv,
          password: tPassword,
          rememberMe: false,
          fcmToken: '',
        ),
      ).thenAnswer((_) async => Left(tFailure));

      final result = await usecase(
        const SignInParams(mssv: tMssv, password: tPassword),
      );

      expect(result, Left(tFailure));
      verify(
        mockRepository.signIn(
          mssv: tMssv,
          password: tPassword,
          rememberMe: false,
          fcmToken: '',
        ),
      );
      verifyNoMoreInteractions(mockRepository);
    });

    test('should pass rememberMe=true to repository', () async {
      when(
        mockRepository.signIn(
          mssv: tMssv,
          password: tPassword,
          rememberMe: true,
          fcmToken: '',
        ),
      ).thenAnswer((_) async => const Right(tEntity));

      await usecase(
        const SignInParams(mssv: tMssv, password: tPassword, rememberMe: true),
      );

      verify(
        mockRepository.signIn(
          mssv: tMssv,
          password: tPassword,
          rememberMe: true,
          fcmToken: '',
        ),
      );
    });
  });
}

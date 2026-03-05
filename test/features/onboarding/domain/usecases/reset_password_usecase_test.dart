import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mockito/mockito.dart';
import 'package:uit_buddy_mobile/core/error/failures.dart';
import 'package:uit_buddy_mobile/features/onboarding/domain/usecases/reset_password_usecase.dart';

import '../../../../mocks/mocks.mocks.dart';

void main() {
  late MockAuthRepository mockRepository;
  late ResetPasswordUsecase usecase;

  setUp(() {
    mockRepository = MockAuthRepository();
    provideDummy<Either<Failure, void>>(const Right(null));
    usecase = ResetPasswordUsecase(authRepository: mockRepository);
  });

  const tMssv = '21521234';
  const tOtpCode = '123456';
  const tNewPassword = 'newPassword123';
  const tConfirmPassword = 'newPassword123';
  const tParams = ResetPasswordParams(
    mssv: tMssv,
    otpCode: tOtpCode,
    newPassword: tNewPassword,
    confirmPassword: tConfirmPassword,
  );

  group('ResetPasswordUsecase', () {
    test(
      'should call repository.resetPassword with all correct parameters',
      () async {
        when(
          mockRepository.resetPassword(
            mssv: tMssv,
            otpCode: tOtpCode,
            newPassword: tNewPassword,
            confirmPassword: tConfirmPassword,
          ),
        ).thenAnswer((_) async => const Right(null));

        await usecase(tParams);

        verify(
          mockRepository.resetPassword(
            mssv: tMssv,
            otpCode: tOtpCode,
            newPassword: tNewPassword,
            confirmPassword: tConfirmPassword,
          ),
        );
        verifyNoMoreInteractions(mockRepository);
      },
    );

    test('should return Right(null) on success', () async {
      when(
        mockRepository.resetPassword(
          mssv: tMssv,
          otpCode: tOtpCode,
          newPassword: tNewPassword,
          confirmPassword: tConfirmPassword,
        ),
      ).thenAnswer((_) async => const Right(null));

      final result = await usecase(tParams);

      expect(result, const Right(null));
    });

    test('should return Failure when repository fails', () async {
      final tFailure = Failure('Invalid OTP code');
      when(
        mockRepository.resetPassword(
          mssv: tMssv,
          otpCode: tOtpCode,
          newPassword: tNewPassword,
          confirmPassword: tConfirmPassword,
        ),
      ).thenAnswer((_) async => Left(tFailure));

      final result = await usecase(tParams);

      expect(result, Left(tFailure));
    });
  });
}

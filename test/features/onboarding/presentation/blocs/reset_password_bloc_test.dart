import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mockito/mockito.dart';
import 'package:uit_buddy_mobile/core/error/failures.dart';
import 'package:uit_buddy_mobile/features/onboarding/domain/usecases/reset_password_usecase.dart';
import 'package:uit_buddy_mobile/features/onboarding/presentation/blocs/reset_password/reset_password_bloc.dart';
import 'package:uit_buddy_mobile/features/onboarding/presentation/blocs/reset_password/reset_password_event.dart';
import 'package:uit_buddy_mobile/features/onboarding/presentation/blocs/reset_password/reset_password_state.dart';

import '../../../../mocks/mocks.mocks.dart';

void main() {
  late MockResetPasswordUsecase mockUsecase;

  const tMssv = '21521234';
  const tOtpCode = '123456';
  const tNewPassword = 'newPassword123';
  const tConfirmPassword = 'newPassword123';

  setUp(() {
    mockUsecase = MockResetPasswordUsecase();
    provideDummy<Either<Failure, void>>(const Right(null));
  });

  group('ResetPasswordBloc', () {
    test('initial state is ResetPasswordState(status: initial)', () {
      expect(
        ResetPasswordBloc(resetPasswordUsecase: mockUsecase).state,
        const ResetPasswordState(status: ResetPasswordStatus.initial),
      );
    });

    blocTest<ResetPasswordBloc, ResetPasswordState>(
      'emits [loading, success] when resetPassword succeeds',
      build: () {
        when(mockUsecase.call(any)).thenAnswer((_) async => const Right(null));
        return ResetPasswordBloc(resetPasswordUsecase: mockUsecase);
      },
      act: (bloc) => bloc.add(
        const ResetPasswordSubmitted(
          mssv: tMssv,
          otpCode: tOtpCode,
          newPassword: tNewPassword,
          confirmPassword: tConfirmPassword,
        ),
      ),
      expect: () => const [
        ResetPasswordState(status: ResetPasswordStatus.loading),
        ResetPasswordState(status: ResetPasswordStatus.success),
      ],
      verify: (_) {
        verify(
          mockUsecase.call(
            const ResetPasswordParams(
              mssv: tMssv,
              otpCode: tOtpCode,
              newPassword: tNewPassword,
              confirmPassword: tConfirmPassword,
            ),
          ),
        );
      },
    );

    blocTest<ResetPasswordBloc, ResetPasswordState>(
      'emits [loading, failure] when resetPassword fails',
      build: () {
        when(
          mockUsecase.call(any),
        ).thenAnswer((_) async => Left(Failure('Invalid OTP code')));
        return ResetPasswordBloc(resetPasswordUsecase: mockUsecase);
      },
      act: (bloc) => bloc.add(
        const ResetPasswordSubmitted(
          mssv: tMssv,
          otpCode: tOtpCode,
          newPassword: tNewPassword,
          confirmPassword: tConfirmPassword,
        ),
      ),
      expect: () => const [
        ResetPasswordState(status: ResetPasswordStatus.loading),
        ResetPasswordState(
          status: ResetPasswordStatus.failure,
          errorMessage: 'Invalid OTP code',
        ),
      ],
    );

    blocTest<ResetPasswordBloc, ResetPasswordState>(
      'emits [loading, failure] when passwords do not match',
      build: () {
        when(
          mockUsecase.call(any),
        ).thenAnswer((_) async => Left(Failure('Passwords do not match')));
        return ResetPasswordBloc(resetPasswordUsecase: mockUsecase);
      },
      act: (bloc) => bloc.add(
        const ResetPasswordSubmitted(
          mssv: tMssv,
          otpCode: tOtpCode,
          newPassword: tNewPassword,
          confirmPassword: 'differentPassword',
        ),
      ),
      expect: () => const [
        ResetPasswordState(status: ResetPasswordStatus.loading),
        ResetPasswordState(
          status: ResetPasswordStatus.failure,
          errorMessage: 'Passwords do not match',
        ),
      ],
    );
  });
}

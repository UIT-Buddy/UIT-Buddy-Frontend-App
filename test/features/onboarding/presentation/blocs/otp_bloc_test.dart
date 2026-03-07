import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mockito/mockito.dart';
import 'package:uit_buddy_mobile/core/error/failures.dart';
import 'package:uit_buddy_mobile/features/onboarding/domain/usecases/forget_password_usecase.dart';
import 'package:uit_buddy_mobile/features/onboarding/presentation/blocs/otp/otp_bloc.dart';
import 'package:uit_buddy_mobile/features/onboarding/presentation/blocs/otp/otp_event.dart';
import 'package:uit_buddy_mobile/features/onboarding/presentation/blocs/otp/otp_state.dart';

import '../../../../mocks/mocks.mocks.dart';

void main() {
  late MockForgetPasswordUsecase mockUsecase;

  const tMssv = '21521234';

  setUp(() {
    mockUsecase = MockForgetPasswordUsecase();
    provideDummy<Either<Failure, void>>(const Right(null));
  });

  group('OtpBloc', () {
    test('initial state is OtpState(status: initial)', () {
      expect(
        OtpBloc(forgetPasswordUsecase: mockUsecase).state,
        const OtpState(status: OtpStatus.initial),
      );
    });

    blocTest<OtpBloc, OtpState>(
      'emits [loading(mssv), sent(mssv)] when forgetPassword succeeds',
      build: () {
        when(mockUsecase.call(any)).thenAnswer((_) async => const Right(null));
        return OtpBloc(forgetPasswordUsecase: mockUsecase);
      },
      act: (bloc) => bloc.add(const OtpSendRequested(mssv: tMssv)),
      expect: () => const [
        OtpState(status: OtpStatus.loading, mssv: tMssv),
        OtpState(status: OtpStatus.sent, mssv: tMssv),
      ],
      verify: (_) {
        verify(mockUsecase.call(const ForgetPasswordParams(mssv: tMssv)));
      },
    );

    blocTest<OtpBloc, OtpState>(
      'emits [loading(mssv), failure] when forgetPassword fails',
      build: () {
        when(
          mockUsecase.call(any),
        ).thenAnswer((_) async => Left(Failure('Student ID not found')));
        return OtpBloc(forgetPasswordUsecase: mockUsecase);
      },
      act: (bloc) => bloc.add(const OtpSendRequested(mssv: tMssv)),
      expect: () => const [
        OtpState(status: OtpStatus.loading, mssv: tMssv),
        OtpState(
          status: OtpStatus.failure,
          mssv: tMssv,
          errorMessage: 'Student ID not found',
        ),
      ],
    );

    blocTest<OtpBloc, OtpState>(
      'stores mssv in state so it can be passed to reset password',
      build: () {
        when(mockUsecase.call(any)).thenAnswer((_) async => const Right(null));
        return OtpBloc(forgetPasswordUsecase: mockUsecase);
      },
      act: (bloc) => bloc.add(const OtpSendRequested(mssv: tMssv)),
      verify: (bloc) {
        expect(bloc.state.mssv, tMssv);
      },
    );
  });
}

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mockito/mockito.dart';
import 'package:uit_buddy_mobile/core/error/failures.dart';
import 'package:uit_buddy_mobile/features/onboarding/domain/entities/signup_complete_entity.dart';
import 'package:uit_buddy_mobile/features/onboarding/domain/usecases/signin_usecase.dart';
import 'package:uit_buddy_mobile/features/onboarding/presentation/blocs/sign_in/sign_in_bloc.dart';
import 'package:uit_buddy_mobile/features/onboarding/presentation/blocs/sign_in/sign_in_event.dart';
import 'package:uit_buddy_mobile/features/onboarding/presentation/blocs/sign_in/sign_in_state.dart';

import '../../../../mocks/mocks.mocks.dart';

void main() {
  late MockSignInUsecase mockUsecase;

  const tMssv = '21521234';
  const tPassword = 'password123';
  const tEntity = SignUpCompleteEntity(
    accessToken: 'access_token',
    refreshToken: 'refresh_token',
    user: SignUpCompleteUserEntity(
      mssv: tMssv,
      fullName: 'Test User',
      email: 'test@uit.edu.vn',
    ),
    cometAuthToken: 'comet_auth_token',
  );

  setUp(() {
    mockUsecase = MockSignInUsecase();
    provideDummy<Either<Failure, SignUpCompleteEntity>>(const Right(tEntity));
  });

  group('SignInBloc', () {
    test('initial state is SignInState(status: initial)', () {
      expect(
        SignInBloc(signInUsecase: mockUsecase).state,
        const SignInState(status: SignInStatus.initial),
      );
    });

    blocTest<SignInBloc, SignInState>(
      'emits [loading, success] when sign in succeeds',
      build: () {
        when(
          mockUsecase.call(any),
        ).thenAnswer((_) async => const Right(tEntity));
        return SignInBloc(signInUsecase: mockUsecase);
      },
      act: (bloc) => bloc.add(
        const SignInPressed(
          mssv: tMssv,
          password: tPassword,
          rememberMe: false,
        ),
      ),
      expect: () => const [
        SignInState(status: SignInStatus.loading),
        SignInState(status: SignInStatus.success),
      ],
      verify: (_) {
        verify(
          mockUsecase.call(
            const SignInParams(mssv: tMssv, password: tPassword),
          ),
        );
      },
    );

    blocTest<SignInBloc, SignInState>(
      'emits [loading, failure] when sign in fails',
      build: () {
        when(
          mockUsecase.call(any),
        ).thenAnswer((_) async => Left(Failure('Invalid credentials')));
        return SignInBloc(signInUsecase: mockUsecase);
      },
      act: (bloc) => bloc.add(
        const SignInPressed(
          mssv: tMssv,
          password: tPassword,
          rememberMe: false,
        ),
      ),
      expect: () => const [
        SignInState(status: SignInStatus.loading),
        SignInState(
          status: SignInStatus.failure,
          errorMessage: 'Invalid credentials',
        ),
      ],
    );

    blocTest<SignInBloc, SignInState>(
      'emits [loading, success] when rememberMe is true',
      build: () {
        when(
          mockUsecase.call(any),
        ).thenAnswer((_) async => const Right(tEntity));
        return SignInBloc(signInUsecase: mockUsecase);
      },
      act: (bloc) => bloc.add(
        const SignInPressed(mssv: tMssv, password: tPassword, rememberMe: true),
      ),
      expect: () => const [
        SignInState(status: SignInStatus.loading),
        SignInState(status: SignInStatus.success),
      ],
      verify: (_) {
        verify(
          mockUsecase.call(
            const SignInParams(
              mssv: tMssv,
              password: tPassword,
              rememberMe: true,
            ),
          ),
        );
      },
    );
  });
}

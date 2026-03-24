import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uit_buddy_mobile/features/onboarding/domain/usecases/signin_usecase.dart';
import 'package:uit_buddy_mobile/features/onboarding/presentation/blocs/sign_in/sign_in_event.dart';
import 'package:uit_buddy_mobile/features/onboarding/presentation/blocs/sign_in/sign_in_state.dart';
import 'package:cometchat_sdk/cometchat_sdk.dart';

class SignInBloc extends Bloc<SignInEvent, SignInState> {
  SignInBloc({required SignInUsecase signInUsecase})
    : _signInUsecase = signInUsecase,
      super(const SignInState()) {
    on<SignInPressed>(_onSignInPressed);
  }

  final SignInUsecase _signInUsecase;

  Future<void> _onSignInPressed(
    SignInPressed event,
    Emitter<SignInState> emit,
  ) async {
    emit(state.copyWith(status: SignInStatus.loading));

    final result = await _signInUsecase(
      SignInParams(
        mssv: event.mssv,
        password: event.password,
        rememberMe: event.rememberMe,
      ),
    );

    result.fold(
      (failure) => emit(
        state.copyWith(
          status: SignInStatus.failure,
          errorMessage: failure.message,
        ),
      ),
      (data) async {
        emit(state.copyWith(status: SignInStatus.success));
        final user = await CometChat.getLoggedInUser();
        if (user == null) {
          await CometChat.loginWithAuthToken(
            data.cometAuthToken,
            onSuccess: (User user) {
              debugPrint("Login CometChat Successful : $user");
            },
            onError: (CometChatException e) {
              debugPrint("Login failed with exception:  ${e.message}");
            },
          );
        }
      },
    );
  }
}

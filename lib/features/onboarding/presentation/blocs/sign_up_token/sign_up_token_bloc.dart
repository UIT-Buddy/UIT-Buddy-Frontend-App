import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cometchat_chat_uikit/cometchat_chat_uikit.dart';
import 'package:uit_buddy_mobile/features/onboarding/domain/usecases/change_ws_token_usecase.dart';
import 'package:uit_buddy_mobile/features/onboarding/domain/usecases/signup_init_usecase.dart';
import 'package:uit_buddy_mobile/features/onboarding/presentation/blocs/sign_up_token/sign_up_token_event.dart';
import 'package:uit_buddy_mobile/features/onboarding/presentation/blocs/sign_up_token/sign_up_token_state.dart';

class SignUpTokenBloc extends Bloc<SignUpTokenEvent, SignUpTokenState> {
  SignUpTokenBloc({
    required SignUpInitUsecase signUpInitUsecase,
    required ChangeWsTokenOnboardingUsecase changeWsTokenUsecase,
  }) : _signUpInitUsecase = signUpInitUsecase,
       _changeWsTokenUsecase = changeWsTokenUsecase,
       super(const SignUpTokenState()) {
    on<SignUpTokenVerifyPressed>(_onVerifyPressed);
    on<ChangeWsTokenPressed>(_onChangeWsTokenPressed);
  }

  final SignUpInitUsecase _signUpInitUsecase;
  final ChangeWsTokenOnboardingUsecase _changeWsTokenUsecase;

  Future<void> _onVerifyPressed(
    SignUpTokenVerifyPressed event,
    Emitter<SignUpTokenState> emit,
  ) async {
    emit(state.copyWith(status: SignUpTokenStatus.loading));

    final result = await _signUpInitUsecase(
      SignUpInitParams(wstoken: event.wstoken),
    );

    result.fold(
      (failure) => emit(
        state.copyWith(
          status: SignUpTokenStatus.failure,
          errorMessage: failure.message,
        ),
      ),
      (entity) => emit(
        state.copyWith(status: SignUpTokenStatus.success, entity: entity),
      ),
    );
  }

  Future<void> _onChangeWsTokenPressed(
    ChangeWsTokenPressed event,
    Emitter<SignUpTokenState> emit,
  ) async {
    emit(state.copyWith(status: SignUpTokenStatus.loading));

    final result = await _changeWsTokenUsecase(
      ChangeWsTokenParams(
        mssv: event.mssv,
        password: event.password,
        wstoken: event.wstoken,
      ),
    );

    result.fold(
      (failure) => emit(
        state.copyWith(
          status: SignUpTokenStatus.failure,
          errorMessage: failure.message,
        ),
      ),
      (data) async {
        emit(state.copyWith(status: SignUpTokenStatus.changeWsTokenSuccess));
        if (data.cometAuthToken != null) {
          await CometChat.loginWithAuthToken(
            data.cometAuthToken!,
            onError: (excep) => {},
            onSuccess: (user) => {},
          );
        }
      },
    );
  }
}

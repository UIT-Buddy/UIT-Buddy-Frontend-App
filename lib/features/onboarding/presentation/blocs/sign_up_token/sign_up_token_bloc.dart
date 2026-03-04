import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uit_buddy_mobile/features/onboarding/domain/usecases/signup_init_usecase.dart';
import 'package:uit_buddy_mobile/features/onboarding/presentation/blocs/sign_up_token/sign_up_token_event.dart';
import 'package:uit_buddy_mobile/features/onboarding/presentation/blocs/sign_up_token/sign_up_token_state.dart';

class SignUpTokenBloc extends Bloc<SignUpTokenEvent, SignUpTokenState> {
  SignUpTokenBloc({required SignUpInitUsecase signUpInitUsecase})
    : _signUpInitUsecase = signUpInitUsecase,
      super(const SignUpTokenState()) {
    on<SignUpTokenVerifyPressed>(_onVerifyPressed);
  }

  final SignUpInitUsecase _signUpInitUsecase;

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
}

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uit_buddy_mobile/features/onboarding/domain/usecases/signup_complete_usecase.dart';
import 'package:uit_buddy_mobile/features/onboarding/presentation/blocs/sign_up_info/sign_up_info_event.dart';
import 'package:uit_buddy_mobile/features/onboarding/presentation/blocs/sign_up_info/sign_up_info_state.dart';

class SignUpInfoBloc extends Bloc<SignUpInfoEvent, SignUpInfoState> {
  SignUpInfoBloc({required SignUpCompleteUsecase signUpCompleteUsecase})
    : _signUpCompleteUsecase = signUpCompleteUsecase,
      super(const SignUpInfoState()) {
    on<SignUpInfoSubmitPressed>(_onSubmitPressed);
  }

  final SignUpCompleteUsecase _signUpCompleteUsecase;

  Future<void> _onSubmitPressed(
    SignUpInfoSubmitPressed event,
    Emitter<SignUpInfoState> emit,
  ) async {
    emit(state.copyWith(status: SignUpInfoStatus.loading));

    final result = await _signUpCompleteUsecase(
      SignUpCompleteParams(
        signupToken: event.signupToken,
        mssv: event.mssv,
        password: event.password,
        confirmPassword: event.confirmPassword,
      ),
    );

    result.fold(
      (failure) => emit(
        state.copyWith(
          status: SignUpInfoStatus.failure,
          errorMessage: failure.message,
        ),
      ),
      (_) => emit(state.copyWith(status: SignUpInfoStatus.success)),
    );
  }
}

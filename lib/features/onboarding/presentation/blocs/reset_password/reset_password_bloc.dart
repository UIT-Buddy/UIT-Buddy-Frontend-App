import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uit_buddy_mobile/features/onboarding/domain/usecases/reset_password_usecase.dart';
import 'package:uit_buddy_mobile/features/onboarding/presentation/blocs/reset_password/reset_password_event.dart';
import 'package:uit_buddy_mobile/features/onboarding/presentation/blocs/reset_password/reset_password_state.dart';

class ResetPasswordBloc extends Bloc<ResetPasswordEvent, ResetPasswordState> {
  ResetPasswordBloc({required ResetPasswordUsecase resetPasswordUsecase})
    : _resetPasswordUsecase = resetPasswordUsecase,
      super(const ResetPasswordState()) {
    on<ResetPasswordSubmitted>(_onResetPasswordSubmitted);
  }

  final ResetPasswordUsecase _resetPasswordUsecase;

  Future<void> _onResetPasswordSubmitted(
    ResetPasswordSubmitted event,
    Emitter<ResetPasswordState> emit,
  ) async {
    emit(state.copyWith(status: ResetPasswordStatus.loading));

    final result = await _resetPasswordUsecase(
      ResetPasswordParams(
        mssv: event.mssv,
        otpCode: event.otpCode,
        newPassword: event.newPassword,
        confirmPassword: event.confirmPassword,
      ),
    );

    result.fold(
      (failure) => emit(
        state.copyWith(
          status: ResetPasswordStatus.failure,
          errorMessage: failure.message,
        ),
      ),
      (_) => emit(state.copyWith(status: ResetPasswordStatus.success)),
    );
  }
}

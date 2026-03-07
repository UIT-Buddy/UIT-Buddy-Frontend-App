import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uit_buddy_mobile/features/onboarding/domain/usecases/forget_password_usecase.dart';
import 'package:uit_buddy_mobile/features/onboarding/presentation/blocs/otp/otp_event.dart';
import 'package:uit_buddy_mobile/features/onboarding/presentation/blocs/otp/otp_state.dart';

class OtpBloc extends Bloc<OtpEvent, OtpState> {
  OtpBloc({required ForgetPasswordUsecase forgetPasswordUsecase})
    : _forgetPasswordUsecase = forgetPasswordUsecase,
      super(const OtpState()) {
    on<OtpSendRequested>(_onOtpSendRequested);
  }

  final ForgetPasswordUsecase _forgetPasswordUsecase;

  Future<void> _onOtpSendRequested(
    OtpSendRequested event,
    Emitter<OtpState> emit,
  ) async {
    emit(state.copyWith(status: OtpStatus.loading, mssv: event.mssv));

    final result = await _forgetPasswordUsecase(
      ForgetPasswordParams(mssv: event.mssv),
    );

    result.fold(
      (failure) => emit(
        state.copyWith(
          status: OtpStatus.failure,
          errorMessage: failure.message,
        ),
      ),
      (_) => emit(state.copyWith(status: OtpStatus.sent)),
    );
  }
}

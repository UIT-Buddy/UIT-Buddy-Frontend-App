import 'package:freezed_annotation/freezed_annotation.dart';

part 'otp_state.freezed.dart';

enum OtpStatus { initial, loading, sent, failure }

@freezed
abstract class OtpState with _$OtpState {
  const factory OtpState({
    @Default(OtpStatus.initial) OtpStatus status,
    @Default('') String mssv,
    String? errorMessage,
  }) = _OtpState;
}

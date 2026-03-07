import 'package:equatable/equatable.dart';

abstract class OtpEvent extends Equatable {
  const OtpEvent();

  @override
  List<Object?> get props => [];
}

class OtpSendRequested extends OtpEvent {
  const OtpSendRequested({required this.mssv});

  final String mssv;

  @override
  List<Object?> get props => [mssv];
}

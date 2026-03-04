import 'package:equatable/equatable.dart';

abstract class SignUpTokenEvent extends Equatable {
  const SignUpTokenEvent();

  @override
  List<Object?> get props => [];
}

class SignUpTokenVerifyPressed extends SignUpTokenEvent {
  const SignUpTokenVerifyPressed({required this.wstoken});

  final String wstoken;

  @override
  List<Object?> get props => [wstoken];
}

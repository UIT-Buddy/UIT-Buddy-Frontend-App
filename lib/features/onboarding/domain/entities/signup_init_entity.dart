import 'package:equatable/equatable.dart';

class SignUpInitEntity extends Equatable {
  const SignUpInitEntity({
    required this.studentId,
    required this.studentName,
    required this.signupToken,
  });

  final String studentId;
  final String studentName;
  final String signupToken;

  @override
  List<Object?> get props => [studentId, studentName, signupToken];
}

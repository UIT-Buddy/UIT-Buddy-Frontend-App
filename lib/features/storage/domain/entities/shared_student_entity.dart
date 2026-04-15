import 'package:equatable/equatable.dart';

enum AccessRole { viewer, owner }

class SharedStudentEntity extends Equatable {
  final StudentEntity student;
  final AccessRole accessRole;
  final DateTime sharedAt;

  const SharedStudentEntity({
    required this.student,
    required this.accessRole,
    required this.sharedAt,
  });

  @override
  List<Object?> get props => [student, accessRole, sharedAt];
}

class StudentEntity extends Equatable {
  final String fullName;
  final String mssv;
  final String avatarUrl;
  final String email;

  const StudentEntity({
    required this.fullName,
    required this.mssv,
    required this.avatarUrl,
    required this.email,
  });

  @override
  List<Object?> get props => [fullName, mssv, avatarUrl, email];
}

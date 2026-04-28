import 'package:equatable/equatable.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

@immutable
class SemesterDetailEntity extends Equatable {
  final String id;
  final int accumulatedCredits;
  final double averageGradeScale10;
  final double averageGradeScale4;
  final List<GradeEntity> grades;
  final int totalCredits;
  final List<int> totalCreditsByCategory;

  const SemesterDetailEntity({
    required this.id,
    required this.accumulatedCredits,
    required this.averageGradeScale10,
    required this.averageGradeScale4,
    required this.grades,
    required this.totalCredits,
    required this.totalCreditsByCategory,
  });

  @override
  List<Object?> get props => [
    id,
    accumulatedCredits,
    averageGradeScale10,
    averageGradeScale4,
    grades,
    totalCredits,
    totalCreditsByCategory,
  ];
}

@immutable
class GradeEntity extends Equatable {
  final String id;
  final String courseCode;
  final String courseName;
  final String courseType;
  final double finalGrade;
  final double labGrade;
  final double midtermGrade;
  final double processGrade;
  final double totalGrade;
  final int credits;

  const GradeEntity({
    required this.id,
    required this.courseCode,
    required this.courseName,
    required this.courseType,
    required this.finalGrade,
    required this.labGrade,
    required this.midtermGrade,
    required this.processGrade,
    required this.totalGrade,
    required this.credits,
  });

  @override
  List<Object?> get props => [
    id,
    courseCode,
    courseName,
    courseType,
    finalGrade,
    labGrade,
    midtermGrade,
    processGrade,
    totalGrade,
    credits,
  ];
}

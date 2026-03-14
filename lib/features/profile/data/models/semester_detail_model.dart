
import 'package:equatable/equatable.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

@immutable
class SemesterDetailModel extends Equatable {
  final String id;
  final int yearStart;
  final int yearEnd;
  final double gpa;
  final int credits;
  final DateTime startDate;
  final DateTime endDate;
  final bool isCurrent;
  final String rank;
  final int semesterNumber;


  const SemesterDetailModel({
    required this.id,
    required this.yearStart,
    required this.yearEnd,
    required this.gpa,
    required this.credits,
    required this.startDate,
    required this.endDate,
    required this.isCurrent,
    required this.rank,
    required this.semesterNumber,

  });

  @override
  List<Object?> get props => [
    id,
    yearStart,
    yearEnd,
    gpa,
    credits,
    startDate,
    endDate,
    isCurrent,
    rank,
    semesterNumber,

  ];
}

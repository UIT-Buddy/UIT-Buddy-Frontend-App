import 'package:equatable/equatable.dart';

enum DeadlineStatus { done, upcoming, overdue, nearDeadline }

class DeadlineEntity extends Equatable {
  final String id;
  final String exerciseName;
  final DateTime dueDate;
  final String? url;
  final DeadlineStatus status;
  final bool isPersonal;
  final String? classCode;

  const DeadlineEntity({
    required this.id,
    required this.exerciseName,
    required this.dueDate,
    this.url,
    required this.status,
    required this.isPersonal,
    this.classCode,
  });

  @override
  List<Object?> get props => [
    id,
    exerciseName,
    dueDate,
    url,
    status,
    isPersonal,
    classCode,
  ];
}

class CourseContentEntity extends Equatable {
  final String courseName;
  final List<DeadlineEntity> exercises;

  const CourseContentEntity({
    required this.courseName,
    required this.exercises,
  });

  @override
  List<Object?> get props => [courseName, exercises];
}

class DeadlineDataEntity extends Equatable {
  final int numberOfDeadlines;
  final List<CourseContentEntity> courseContents;

  const DeadlineDataEntity({
    required this.numberOfDeadlines,
    required this.courseContents,
  });

  @override
  List<Object?> get props => [numberOfDeadlines, courseContents];
}

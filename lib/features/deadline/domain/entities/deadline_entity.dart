import 'package:equatable/equatable.dart';

class DeadlineEntity extends Equatable {
  final String id;
  final String exerciseName;
  final DateTime dueDate;
  final String? url;
  final String status;
  final bool isPersonal;

  const DeadlineEntity({
    required this.id,
    required this.exerciseName,
    required this.dueDate,
    this.url,
    required this.status,
    required this.isPersonal,
  });

  @override
  List<Object?> get props => [
    id,
    exerciseName,
    dueDate,
    url,
    status,
    isPersonal,
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

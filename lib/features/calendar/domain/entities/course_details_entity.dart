import 'package:equatable/equatable.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

@immutable
class CourseDetailsEntity extends Equatable {
  final String courseId;
  final String classId;
  final String? labOfClassId;
  final bool isBlendedLearning;
  final String courseName;
  final int startPeriod;
  final int endPeriod;
  final String startTime;
  final String endTime;
  final DateTime startDate;
  final DateTime endDate;
  final int credits;
  final int dayOfWeek;
  final String lecturer;
  final String room;
  final List<DeadlineDetailEntity> deadlines;

  const CourseDetailsEntity({
    required this.courseId,
    required this.classId,
    this.labOfClassId,
    this.isBlendedLearning = false,
    required this.courseName,
    required this.startPeriod,
    required this.endPeriod,
    required this.startTime,
    required this.endTime,
    required this.startDate,
    required this.endDate,
    required this.credits,
    required this.dayOfWeek,
    required this.lecturer,
    required this.room,
    required this.deadlines,
  });

  @override
  List<Object?> get props => [
    courseId,
    classId,
    labOfClassId,
    isBlendedLearning,
    courseName,
    startPeriod,
    endPeriod,
    startTime,
    endTime,
    startDate,
    endDate,
    credits,
    dayOfWeek,
    lecturer,
    room,
    deadlines,
  ];
}

enum TaskEntityStatus { done, upcoming, nearDeadline, overdue }

@immutable
class DeadlineDetailEntity extends Equatable {
  final String id;
  final String title;
  final TaskEntityStatus status;
  final DateTime deadline;
  final String? url;

  const DeadlineDetailEntity({
    required this.id,
    required this.title,
    required this.status,
    required this.deadline,
    this.url,
  });

  @override
  List<Object?> get props => [id, title, status, deadline, url];
}

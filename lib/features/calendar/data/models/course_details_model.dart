import 'package:equatable/equatable.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

@immutable
class CourseDetailsModel extends Equatable {
  const CourseDetailsModel({
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
    this.deadlines = const [],
  });

  /// Course code, e.g. "SE347"
  final String courseId;

  /// Class / section ID, e.g. "SE347.Q14"
  final String classId;

  /// If set, this is a lab section of the class with this ID.
  /// Lab sections share the same background colour in the timetable.
  /// e.g. "SE347.Q14" for the lab class "SE347.Q14.1"
  final String? labOfClassId;

  /// Whether this course uses Blended Learning (self-study / project / internship).
  /// BL courses are shown in the dedicated BL row below the period grid.
  final bool isBlendedLearning;

  /// e.g. "Công nghệ web và ứng dụng"
  final String courseName;

  /// 1-based period number (1–10) when the class starts.
  final int startPeriod;

  /// 1-based period number (1–10) when the class ends.
  final int endPeriod;

  /// ISO-8601 time string, e.g. "07:30"
  final String startTime;

  /// ISO-8601 time string, e.g. "09:00"
  final String endTime;

  /// First day of the semester this course is active.
  final String startDate; // "yyyy-MM-dd"

  /// Last day of the semester this course is active.
  final String endDate; // "yyyy-MM-dd"

  final int credits;

  /// 2 = Monday … 7 = Saturday (Vietnamese calendar convention).
  final int dayOfWeek;

  final String lecturer;
  final String room;

  final List<DeadlineDetailInCourseModel> deadlines;

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

@immutable
class DeadlineDetailInCourseModel extends Equatable {
  const DeadlineDetailInCourseModel({
    required this.id,
    required this.title,
    required this.status,
    required this.deadline,
  });

  final String id;
  final String title;

  /// "done" | "upcoming" | "nearDeadline" | "overdue"
  final String status;

  /// ISO-8601 datetime, e.g. "2026-03-15T23:59:00"
  final String deadline;

  @override
  List<Object?> get props => [id, title, status, deadline];
}

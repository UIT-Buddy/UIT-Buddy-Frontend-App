import 'package:equatable/equatable.dart';

abstract class CoursesModeEvent extends Equatable {
  const CoursesModeEvent();

  @override
  List<Object?> get props => [];
}

class CoursesModeStarted extends CoursesModeEvent {
  const CoursesModeStarted();
}

class CoursesModePreviousSemester extends CoursesModeEvent {
  const CoursesModePreviousSemester();
}

class CoursesModeNextSemester extends CoursesModeEvent {
  const CoursesModeNextSemester();
}

class CoursesModeUploadScheduleRequested extends CoursesModeEvent {
  const CoursesModeUploadScheduleRequested({
    required this.filePath,
    required this.fileName,
  });

  final String filePath;
  final String fileName;

  @override
  List<Object?> get props => [filePath, fileName];
}

class CoursesModeSyncAssignmentsRequested extends CoursesModeEvent {
  const CoursesModeSyncAssignmentsRequested({this.month, this.year});

  final int? month;
  final int? year;

  @override
  List<Object?> get props => [month, year];
}

/// Triggers lazy-load of deadlines for a single course.
class CoursesModeSyncCourseAssignmentsRequested extends CoursesModeEvent {
  const CoursesModeSyncCourseAssignmentsRequested({required this.classId});

  final String classId;

  @override
  List<Object?> get props => [classId];
}

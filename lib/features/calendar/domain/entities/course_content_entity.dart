import 'package:equatable/equatable.dart';
import 'package:uit_buddy_mobile/features/calendar/domain/entities/course_details_entity.dart';

/// Represents deadlines / exercises for a single course from Moodle.
/// Used for lazy-loading deadlines per course via syncCourseAssignments.
class CourseContentEntity extends Equatable {
  const CourseContentEntity({
    required this.courseName,
    required this.exercises,
  });

  final String courseName;
  final List<DeadlineDetailEntity> exercises;

  @override
  List<Object?> get props => [courseName, exercises];
}

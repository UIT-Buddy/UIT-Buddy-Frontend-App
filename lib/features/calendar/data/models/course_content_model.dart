import 'package:uit_buddy_mobile/features/calendar/data/models/course_details_model.dart';

/// Represents the per-course deadline response from Moodle:
/// { "courseName": "...", "exercises": [...] }
class CourseContentModel {
  const CourseContentModel({required this.courseName, required this.exercises});

  final String courseName;
  final List<DeadlineDetailInCourseModel> exercises;

  factory CourseContentModel.fromJson(Map<String, dynamic> json) {
    final exercisesJson = json['exercises'] as List<dynamic>? ?? [];
    return CourseContentModel(
      courseName: json['courseName'] as String? ?? '',
      exercises: exercisesJson
          .map(
            (e) =>
                DeadlineDetailInCourseModel.fromJson(e as Map<String, dynamic>),
          )
          .toList(),
    );
  }
}

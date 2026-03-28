import 'package:freezed_annotation/freezed_annotation.dart';

part 'course_details_model.freezed.dart';
part 'course_details_model.g.dart';

int _periodFromJson(dynamic value) {
  if (value is int) return value;
  if (value is String) return int.tryParse(value) ?? 0;
  return 0;
}

dynamic _deadlinesToJson(List<DeadlineDetailInCourseModel> deadlines) {
  if (deadlines.isEmpty) return null;
  return {'exercises': deadlines.map((d) => d.toJson()).toList()};
}

List<DeadlineDetailInCourseModel> _deadlinesFromJson(dynamic value) {
  if (value == null) return const [];
  if (value is Map<String, dynamic>) {
    final exercises = value['exercises'] as List<dynamic>?;
    if (exercises == null) return const [];
    return exercises.map((e) {
      final model = DeadlineDetailInCourseModel.fromJson(
        e as Map<String, dynamic>,
      );
      // Generate an id from the url hashcode if id is empty
      if (model.id.isEmpty && model.url != null) {
        return model.copyWith(id: model.url.hashCode.toString());
      }
      return model;
    }).toList();
  }
  return const [];
}

@freezed
abstract class CourseDetailsModel with _$CourseDetailsModel {
  const factory CourseDetailsModel({
    /// Course code, e.g. "IT002"
    @JsonKey(name: 'courseCode') required String courseId,

    /// Class / section ID, e.g. "IT002.P215.2"
    required String classId,

    /// If set, this is a lab section of the class with this ID.
    String? labOfClassId,

    /// Whether this course uses Blended Learning.
    @Default(false) bool isBlendedLearning,

    /// e.g. "Lập trình hướng đối tượng"
    required String courseName,

    /// 1-based period number when the class starts (JSON may be a String).
    @JsonKey(fromJson: _periodFromJson) required int startPeriod,

    /// 1-based period number when the class ends (JSON may be a String).
    @JsonKey(fromJson: _periodFromJson) required int endPeriod,

    /// ISO-8601 time string, e.g. "07:30"
    required String startTime,

    /// ISO-8601 time string, e.g. "09:00"
    required String endTime,

    /// First day the course is active, e.g. "2025-02-17"
    required String startDate,

    /// Last day the course is active, e.g. "2025-06-07"
    required String endDate,

    required int credits,

    /// 2 = Monday … 7 = Saturday (Vietnamese calendar convention).
    required int dayOfWeek,

    required String lecturer,

    /// Room code, e.g. "B2.12"
    @JsonKey(name: 'roomCode') required String room,

    /// Deadlines parsed from the nested `deadline` JSON object.
    @JsonKey(
      name: 'deadline',
      fromJson: _deadlinesFromJson,
      toJson: _deadlinesToJson,
    )
    @Default([])
    List<DeadlineDetailInCourseModel> deadlines,
  }) = _CourseDetailsModel;

  factory CourseDetailsModel.fromJson(Map<String, dynamic> json) =>
      _$CourseDetailsModelFromJson(json);
}

@freezed
abstract class DeadlineDetailInCourseModel with _$DeadlineDetailInCourseModel {
  const factory DeadlineDetailInCourseModel({
    /// Generated from URL hashcode when missing.
    @Default('') String id,

    /// Exercise name.
    @JsonKey(name: 'exerciseName') required String title,

    /// "DONE" | "OVERDUE" | etc.
    required String status,

    /// ISO-8601 datetime, e.g. "2025-06-11T12:45:00"
    @JsonKey(name: 'dueDate') required String deadline,

    /// Link to the exercise on courses.uit.edu.vn
    String? url,
  }) = _DeadlineDetailInCourseModel;

  factory DeadlineDetailInCourseModel.fromJson(Map<String, dynamic> json) =>
      _$DeadlineDetailInCourseModelFromJson(json);
}

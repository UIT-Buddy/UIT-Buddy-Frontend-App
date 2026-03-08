import 'package:equatable/equatable.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

@immutable
class CourseEntity extends Equatable {
  const CourseEntity({required this.courseId, required this.courseName});

  final String courseId;
  final String courseName;

  /// e.g. "SE347.Q11 - Công nghệ web và ứng dụng"
  String get displayName => '$courseId - $courseName';

  @override
  List<Object?> get props => [courseId, courseName];
}

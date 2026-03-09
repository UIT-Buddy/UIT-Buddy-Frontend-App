import 'package:equatable/equatable.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

@immutable
class CourseModel extends Equatable {
  const CourseModel({required this.courseId, required this.courseName});

  final String courseId;
  final String courseName;

  @override
  List<Object?> get props => [courseId, courseName];
}

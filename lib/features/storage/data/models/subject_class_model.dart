import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:uit_buddy_mobile/features/storage/domain/entities/course_entity.dart';

@immutable
class SubjectClassModel extends Equatable {
  final String classCode;
  final String courseCode;
  final CourseEntity course;

  const SubjectClassModel({
    required this.classCode,
    required this.courseCode,
    required this.course,
  });

  @override
  List<Object?> get props => [classCode, courseCode, course];
}
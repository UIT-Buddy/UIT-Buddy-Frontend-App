import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

@immutable
class CourseEntity extends Equatable {
  final String courseCode;
  final String courseName;

  const CourseEntity({required this.courseCode, required this.courseName});

  @override
  List<Object?> get props => [courseCode, courseName];
}

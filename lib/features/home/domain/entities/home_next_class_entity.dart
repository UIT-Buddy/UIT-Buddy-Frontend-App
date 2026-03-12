import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

@immutable
class HomeNextClassEntity extends Equatable {
  final String courseCode;
  final String courseName;
  final String room;
  final String lecturer;
  final int minutesUntilStart;
  final int memberCount;

  const HomeNextClassEntity({
    required this.courseCode,
    required this.courseName,
    required this.room,
    required this.lecturer,
    required this.minutesUntilStart,
    required this.memberCount,
  });

  @override
  List<Object?> get props => [
    courseCode,
    courseName,
    room,
    lecturer,
    minutesUntilStart,
    memberCount,
  ];
}

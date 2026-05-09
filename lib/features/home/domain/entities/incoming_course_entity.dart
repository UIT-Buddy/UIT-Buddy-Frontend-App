import 'package:equatable/equatable.dart';
import 'package:uit_buddy_mobile/features/home/domain/entities/incoming_deadline_entity.dart';

class IncomingCourseEntity extends Equatable {
  const IncomingCourseEntity({
    required this.remainingTime,
    required this.studentsInClass,
    required this.courseCode,
    required this.courseName,
    required this.roomCode,
    required this.lecturerName,
  });

  final RemainingTimeEntity remainingTime;
  final int studentsInClass;
  final String courseCode;
  final String courseName;
  final String roomCode;
  final String lecturerName;

  @override
  List<Object?> get props => [
    remainingTime,
    studentsInClass,
    courseCode,
    courseName,
    roomCode,
    lecturerName,
  ];
}

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

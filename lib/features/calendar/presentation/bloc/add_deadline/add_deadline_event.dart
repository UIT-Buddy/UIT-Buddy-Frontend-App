import 'package:equatable/equatable.dart';

abstract class AddDeadlineEvent extends Equatable {
  const AddDeadlineEvent();

  @override
  List<Object?> get props => [];
}

class AddDeadlineStarted extends AddDeadlineEvent {
  const AddDeadlineStarted();
}

class AddDeadlineSearchCoursesRequested extends AddDeadlineEvent {
  const AddDeadlineSearchCoursesRequested(this.query);

  final String query;

  @override
  List<Object?> get props => [query];
}

class AddDeadlineCreateRequested extends AddDeadlineEvent {
  const AddDeadlineCreateRequested({
    required this.name,
    required this.courseId,
    required this.deadline,
  });

  final String name;
  final String courseId;
  final DateTime deadline;

  @override
  List<Object?> get props => [name, courseId, deadline];
}

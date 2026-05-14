import 'package:equatable/equatable.dart';

abstract class DeadlineEvent extends Equatable {
  const DeadlineEvent();

  @override
  List<Object?> get props => [];
}

class FetchDeadlinesRequested extends DeadlineEvent {
  const FetchDeadlinesRequested();

  @override
  List<Object?> get props => [];
}

class FetchDeadlineRequested extends DeadlineEvent {
  final String id;

  const FetchDeadlineRequested(this.id);

  @override
  List<Object?> get props => [id];
}

class UpdateDeadlineRequested extends DeadlineEvent {
  final String exerciseName;
  final String studentTaskId;
  final String status;
  final DateTime dueDate;

  const UpdateDeadlineRequested({
    required this.exerciseName,
    required this.studentTaskId,
    required this.status,
    required this.dueDate,
  });

  @override
  List<Object?> get props => [exerciseName, studentTaskId, status, dueDate];
}

class CreateDeadlineRequested extends DeadlineEvent {
  final String exerciseName;
  final String classCode;
  final DateTime dueDate;

  const CreateDeadlineRequested({
    required this.exerciseName,
    required this.classCode,
    required this.dueDate,
  });

  @override
  List<Object?> get props => [exerciseName, classCode, dueDate];
}

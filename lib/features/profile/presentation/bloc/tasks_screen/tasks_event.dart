import 'package:equatable/equatable.dart';
import 'package:uit_buddy_mobile/features/profile/domain/entities/task_entity.dart';

abstract class TasksEvent extends Equatable {
  const TasksEvent();

  @override
  List<Object?> get props => [];
}

class TasksLoaded extends TasksEvent {
  const TasksLoaded();
}

class TaskCompleted extends TasksEvent {
  const TaskCompleted({required this.taskId});
  final String taskId;

  @override
  List<Object?> get props => [taskId];
}

class TaskDeleted extends TasksEvent {
  const TaskDeleted({required this.taskId});
  final String taskId;

  @override
  List<Object?> get props => [taskId];
}

class TaskCreated extends TasksEvent {
  const TaskCreated({required this.task});
  final TaskEntity task;

  @override
  List<Object?> get props => [task];
}

class TaskUpdated extends TasksEvent {
  const TaskUpdated({required this.task});
  final TaskEntity task;

  @override
  List<Object?> get props => [task];
}

import 'package:equatable/equatable.dart';
import 'package:uit_buddy_mobile/features/profile/domain/entities/task_detail_entity.dart';
import 'package:uit_buddy_mobile/features/profile/domain/entities/task_entity.dart';

enum TasksStatus { initial, loading, loaded, error }

class TasksState extends Equatable {
  const TasksState({
    this.status = TasksStatus.initial,
    this.tasks = const [],
    this.errorMessage,
  });

  final TasksStatus status;
  final List<TaskEntity> tasks;
  final String? errorMessage;

  List<TaskEntity> get upcomingTasks =>
      tasks.where((t) => t.taskDetail.status == TaskStatus.pending).toList();

  List<TaskEntity> get finishedTasks =>
      tasks.where((t) => t.taskDetail.status == TaskStatus.completed).toList();

  List<TaskEntity> get lateTasks =>
      tasks.where((t) => t.taskDetail.status == TaskStatus.overdue).toList();

  TasksState copyWith({
    TasksStatus? status,
    List<TaskEntity>? tasks,
    String? errorMessage,
  }) {
    return TasksState(
      status: status ?? this.status,
      tasks: tasks ?? this.tasks,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, tasks, errorMessage];
}

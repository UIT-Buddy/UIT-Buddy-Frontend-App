import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uit_buddy_mobile/features/profile/domain/entities/task_detail_entity.dart';
import 'package:uit_buddy_mobile/features/profile/domain/usecases/create_task_usecase.dart';
import 'package:uit_buddy_mobile/features/profile/domain/usecases/delete_task_usecase.dart';
import 'package:uit_buddy_mobile/features/profile/domain/usecases/get_tasks_usecase.dart';
import 'package:uit_buddy_mobile/features/profile/domain/usecases/mark_task_completed_usecase.dart';
import 'package:uit_buddy_mobile/features/profile/domain/usecases/update_task_usecase.dart';
import 'package:uit_buddy_mobile/features/profile/presentation/bloc/tasks_screen/tasks_event.dart';
import 'package:uit_buddy_mobile/features/profile/presentation/bloc/tasks_screen/tasks_state.dart';

class TasksBloc extends Bloc<TasksEvent, TasksState> {
  TasksBloc({
    required GetTasksUsecase getTasksUsecase,
    required MarkTaskCompletedUsecase markTaskCompletedUsecase,
    required DeleteTaskUsecase deleteTaskUsecase,
    required CreateTaskUsecase createTaskUsecase,
    required UpdateTaskUsecase updateTaskUsecase,
  })  : _getTasksUsecase = getTasksUsecase,
        _markTaskCompletedUsecase = markTaskCompletedUsecase,
        _deleteTaskUsecase = deleteTaskUsecase,
        _createTaskUsecase = createTaskUsecase,
        _updateTaskUsecase = updateTaskUsecase,
        super(const TasksState()) {
    on<TasksLoaded>(_onTasksLoaded);
    on<TaskCompleted>(_onTaskCompleted);
    on<TaskDeleted>(_onTaskDeleted);
    on<TaskCreated>(_onTaskCreated);
    on<TaskUpdated>(_onTaskUpdated);
  }

  final GetTasksUsecase _getTasksUsecase;
  final MarkTaskCompletedUsecase _markTaskCompletedUsecase;
  final DeleteTaskUsecase _deleteTaskUsecase;
  final CreateTaskUsecase _createTaskUsecase;
  final UpdateTaskUsecase _updateTaskUsecase;

  Future<void> _onTasksLoaded(
    TasksLoaded event,
    Emitter<TasksState> emit,
  ) async {
    emit(state.copyWith(status: TasksStatus.loading));
    final result = await _getTasksUsecase(null);
    result.fold(
      (failure) => emit(
        state.copyWith(
          status: TasksStatus.error,
          errorMessage: failure.message,
        ),
      ),
      (tasks) => emit(state.copyWith(status: TasksStatus.loaded, tasks: tasks)),
    );
  }

  Future<void> _onTaskCompleted(
    TaskCompleted event,
    Emitter<TasksState> emit,
  ) async {
    final result = await _markTaskCompletedUsecase(
      MarkTaskCompletedParams(taskId: event.taskId),
    );
    result.fold(
      (failure) => emit(state.copyWith(errorMessage: failure.message)),
      (_) {
        final updatedTasks = state.tasks.map((t) {
          if (t.id == event.taskId) {
            return t.copyWith(
              taskDetail: t.taskDetail.copyWith(status: TaskStatus.completed),
            );
          }
          return t;
        }).toList();
        emit(state.copyWith(tasks: updatedTasks));
      },
    );
  }

  Future<void> _onTaskDeleted(
    TaskDeleted event,
    Emitter<TasksState> emit,
  ) async {
    final result = await _deleteTaskUsecase(
      DeleteTaskParams(taskId: event.taskId),
    );
    result.fold(
      (failure) => emit(state.copyWith(errorMessage: failure.message)),
      (_) {
        final updatedTasks =
            state.tasks.where((t) => t.id != event.taskId).toList();
        emit(state.copyWith(tasks: updatedTasks));
      },
    );
  }

  Future<void> _onTaskCreated(
    TaskCreated event,
    Emitter<TasksState> emit,
  ) async {
    final result = await _createTaskUsecase(event.task);
    result.fold(
      (failure) => emit(state.copyWith(errorMessage: failure.message)),
      (task) => emit(state.copyWith(tasks: [...state.tasks, task])),
    );
  }

  Future<void> _onTaskUpdated(
    TaskUpdated event,
    Emitter<TasksState> emit,
  ) async {
    final result = await _updateTaskUsecase(event.task);
    result.fold(
      (failure) => emit(state.copyWith(errorMessage: failure.message)),
      (updated) {
        final updatedTasks = state.tasks.map((t) {
          return t.id == updated.id ? updated : t;
        }).toList();
        emit(state.copyWith(tasks: updatedTasks));
      },
    );
  }
}

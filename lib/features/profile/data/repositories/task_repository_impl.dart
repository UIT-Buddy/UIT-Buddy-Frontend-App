import 'package:fpdart/fpdart.dart';
import 'package:uit_buddy_mobile/core/error/failures.dart';
import 'package:uit_buddy_mobile/features/profile/data/datasources/task_datasource_interface.dart';
import 'package:uit_buddy_mobile/features/profile/data/mapper/task_mapper.dart';
import 'package:uit_buddy_mobile/features/profile/domain/entities/task_entity.dart';
import 'package:uit_buddy_mobile/features/profile/domain/repositories/task_repository.dart';

class TaskRepositoryImpl implements TaskRepository {
  TaskRepositoryImpl({required TaskDatasourceInterface taskDatasourceInterface})
    : _taskDatasource = taskDatasourceInterface;

  final TaskDatasourceInterface _taskDatasource;

  @override
  Future<Either<Failure, List<TaskEntity>>> getTasks() async {
    try {
      final models = await _taskDatasource.getTasks();
      return Right(models.map((m) => m.toEntity()).toList());
    } on Exception catch (e) {
      return Left(Failure.fromException(e));
    }
  }

  @override
  Future<Either<Failure, TaskEntity>> createTask({
    required TaskEntity task,
  }) async {
    try {
      final model = await _taskDatasource.createTask(task: task.toModel());
      return Right(model.toEntity());
    } on Exception catch (e) {
      return Left(Failure.fromException(e));
    }
  }

  @override
  Future<Either<Failure, TaskEntity>> updateTask({
    required TaskEntity task,
  }) async {
    try {
      final model = await _taskDatasource.updateTask(task: task.toModel());
      return Right(model.toEntity());
    } on Exception catch (e) {
      return Left(Failure.fromException(e));
    }
  }

  @override
  Future<Either<Failure, void>> deleteTask({required String taskId}) async {
    try {
      await _taskDatasource.deleteTask(taskId: taskId);
      return const Right(null);
    } on Exception catch (e) {
      return Left(Failure.fromException(e));
    }
  }

  @override
  Future<Either<Failure, void>> markTaskCompleted({
    required String taskId,
  }) async {
    try {
      await _taskDatasource.markTaskCompleted(taskId: taskId);
      return const Right(null);
    } on Exception catch (e) {
      return Left(Failure.fromException(e));
    }
  }
}

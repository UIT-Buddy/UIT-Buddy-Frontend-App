import 'package:fpdart/fpdart.dart';
import 'package:uit_buddy_mobile/core/error/failures.dart';
import 'package:uit_buddy_mobile/features/profile/domain/entities/task_entity.dart';

abstract interface class TaskRepository {
  Future<Either<Failure, List<TaskEntity>>> getTasks();
  Future<Either<Failure, TaskEntity>> createTask({required TaskEntity task});
  Future<Either<Failure, TaskEntity>> updateTask({required TaskEntity task});
  Future<Either<Failure, void>> deleteTask({required String taskId});
  Future<Either<Failure, void>> markTaskCompleted({required String taskId});
}
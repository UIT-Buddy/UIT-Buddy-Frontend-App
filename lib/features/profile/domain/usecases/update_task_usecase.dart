import 'package:fpdart/fpdart.dart';
import 'package:uit_buddy_mobile/core/error/failures.dart';
import 'package:uit_buddy_mobile/core/usecase/usecase_interface.dart';
import 'package:uit_buddy_mobile/features/profile/domain/entities/task_entity.dart';
import 'package:uit_buddy_mobile/features/profile/domain/repositories/task_repository.dart';

class UpdateTaskUsecase implements UseCase<TaskEntity, TaskEntity> {
  UpdateTaskUsecase({required TaskRepository taskRepository})
    : _taskRepository = taskRepository;
  final TaskRepository _taskRepository;

  @override
  Future<Either<Failure, TaskEntity>> call(TaskEntity params) async =>
      _taskRepository.updateTask(task: params);
}

import 'package:fpdart/fpdart.dart';
import 'package:uit_buddy_mobile/core/error/failures.dart';
import 'package:uit_buddy_mobile/core/usecase/usecase_interface.dart';
import 'package:uit_buddy_mobile/features/profile/domain/entities/task_entity.dart';
import 'package:uit_buddy_mobile/features/profile/domain/repositories/task_repository.dart';

class GetTasksUsecase implements UseCase<List<TaskEntity>, void> {
  GetTasksUsecase({required TaskRepository taskRepository})
    : _taskRepository = taskRepository;
  final TaskRepository _taskRepository;
  @override
  Future<Either<Failure, List<TaskEntity>>> call(void params) async =>
      _taskRepository.getTasks();
}

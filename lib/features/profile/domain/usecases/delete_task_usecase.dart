import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:uit_buddy_mobile/core/error/failures.dart';
import 'package:uit_buddy_mobile/core/usecase/usecase_interface.dart';
import 'package:uit_buddy_mobile/features/profile/domain/repositories/task_repository.dart';

class DeleteTaskUsecase implements UseCase<void, DeleteTaskParams> {
  DeleteTaskUsecase({required TaskRepository taskRepository})
    : _taskRepository = taskRepository;
  final TaskRepository _taskRepository;

  @override
  Future<Either<Failure, void>> call(DeleteTaskParams params) async =>
      _taskRepository.deleteTask(taskId: params.taskId);
}

@immutable
class DeleteTaskParams extends Equatable {
  const DeleteTaskParams({required this.taskId});
  final String taskId;

  @override
  List<Object?> get props => [taskId];
}

import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:uit_buddy_mobile/core/error/failures.dart';
import 'package:uit_buddy_mobile/core/usecase/usecase_interface.dart';
import 'package:uit_buddy_mobile/features/profile/domain/repositories/task_repository.dart';

class MarkTaskCompletedUsecase
    implements UseCase<void, MarkTaskCompletedParams> {
  MarkTaskCompletedUsecase({required TaskRepository taskRepository})
    : _taskRepository = taskRepository;
  final TaskRepository _taskRepository;

  @override
  Future<Either<Failure, void>> call(MarkTaskCompletedParams params) async =>
      _taskRepository.markTaskCompleted(taskId: params.taskId);
}

@immutable
class MarkTaskCompletedParams extends Equatable {
  const MarkTaskCompletedParams({required this.taskId});
  final String taskId;

  @override
  List<Object?> get props => [taskId];
}

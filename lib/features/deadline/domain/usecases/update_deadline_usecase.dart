import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';
import 'package:uit_buddy_mobile/core/error/failures.dart';
import 'package:uit_buddy_mobile/core/usecase/usecase_interface.dart';
import 'package:uit_buddy_mobile/features/deadline/domain/repositories/deadline_repository.dart';

class UpdateDeadlineUsecase implements UseCase<void, UpdateDeadlineParams> {
  final DeadlineRepository repository;

  UpdateDeadlineUsecase(this.repository);

  @override
  Future<Either<Failure, void>> call(UpdateDeadlineParams params) async {
    return await repository.updateDeadline(
      studentTaskId: params.studentTaskId,
      exerciseName: params.exerciseName,
      dueDate: params.dueDate,
      status: params.status,
    );
  }
}

class UpdateDeadlineParams extends Equatable {
  final String studentTaskId;
  final String exerciseName;
  final DateTime dueDate;
  final String status;

  const UpdateDeadlineParams({
    required this.studentTaskId,
    required this.exerciseName,
    required this.dueDate,
    required this.status,
  });

  @override
  List<Object?> get props => [studentTaskId, exerciseName, dueDate, status];
}

import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';
import 'package:uit_buddy_mobile/core/error/failures.dart';
import 'package:uit_buddy_mobile/core/usecase/usecase_interface.dart';
import 'package:uit_buddy_mobile/features/deadline/domain/repositories/deadline_repository.dart';

class CreateDeadlineUsecase implements UseCase<void, CreateDeadlineParams> {
  final DeadlineRepository repository;

  CreateDeadlineUsecase(this.repository);

  @override
  Future<Either<Failure, void>> call(CreateDeadlineParams params) async {
    return await repository.createDeadline(
      classCode: params.classCode,
      dueDate: params.dueDate,
      exerciseName: params.exerciseName,
    );
  }
}

class CreateDeadlineParams extends Equatable {
  final String classCode;
  final String exerciseName;
  final DateTime dueDate;

  const CreateDeadlineParams({
    required this.classCode,
    required this.exerciseName,
    required this.dueDate,
  });

  @override
  List<Object?> get props => [classCode, exerciseName, dueDate];
}

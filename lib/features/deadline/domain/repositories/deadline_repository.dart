import 'package:fpdart/fpdart.dart';
import 'package:uit_buddy_mobile/core/error/failures.dart';
import 'package:uit_buddy_mobile/features/deadline/domain/entities/deadline_entity.dart';

abstract interface class DeadlineRepository {
  Future<Either<Failure, DeadlineDataEntity>> getDeadlines();
  Future<Either<Failure, void>> createDeadline({
    required String classCode,
    required DateTime dueDate,
    required String exerciseName,
  });
  Future<Either<Failure, void>> updateDeadline({
    required String studentTaskId,
    required DateTime dueDate,
    required String exerciseName,
    required String status,
  });
  Future<Either<Failure, DeadlineEntity>> getDeadlineDetail(String deadlineId);
}

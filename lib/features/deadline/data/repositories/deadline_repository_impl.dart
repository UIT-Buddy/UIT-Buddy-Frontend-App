import 'package:fpdart/fpdart.dart';
import 'package:uit_buddy_mobile/core/error/failures.dart';
import 'package:uit_buddy_mobile/features/deadline/data/datasources/deadline_datasource.dart';
import 'package:uit_buddy_mobile/features/deadline/domain/entities/deadline_entity.dart';
import 'package:uit_buddy_mobile/features/deadline/domain/repositories/deadline_repository.dart';

class DeadlineRepositoryImpl implements DeadlineRepository {
  DeadlineRepositoryImpl({required DeadlineDatasource deadlineDatasource})
    : _deadlineDatasource = deadlineDatasource;

  final DeadlineDatasource _deadlineDatasource;

  @override
  Future<Either<Failure, DeadlineDataEntity>> getDeadlines() async {
    try {
      final model = await _deadlineDatasource.getDeadlines();
      return Right(model.toEntity());
    } on Exception catch (e) {
      return Left(Failure.fromException(e));
    }
  }

  @override
  Future<Either<Failure, void>> createDeadline({
    required String classCode,
    required DateTime dueDate,
    required String exerciseName,
  }) async {
    try {
      await _deadlineDatasource.createDeadline(
        classCode: classCode,
        dueDate: dueDate,
        exerciseName: exerciseName,
      );
      return const Right(null);
    } on Exception catch (e) {
      return Left(Failure.fromException(e));
    }
  }

  @override
  Future<Either<Failure, void>> updateDeadline({
    required String studentTaskId,
    required DateTime dueDate,
    required String exerciseName,
    required String status,
  }) async {
    try {
      await _deadlineDatasource.updateDeadline(
        studentTaskId: studentTaskId,
        dueDate: dueDate,
        exerciseName: exerciseName,
        status: status,
      );
      return const Right(null);
    } on Exception catch (e) {
      return Left(Failure.fromException(e));
    }
  }

  @override
  Future<Either<Failure, DeadlineEntity>> getDeadlineDetail(
    String deadlineId,
  ) async {
    try {
      final model = await _deadlineDatasource.getDeadlineDetail(deadlineId);
      return Right(model.toEntity());
    } on Exception catch (e) {
      return Left(Failure.fromException(e));
    }
  }
}

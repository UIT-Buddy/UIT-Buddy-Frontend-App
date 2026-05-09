import 'package:fpdart/fpdart.dart';
import 'package:uit_buddy_mobile/core/error/failures.dart';
import 'package:uit_buddy_mobile/core/usecase/usecase_interface.dart';
import 'package:uit_buddy_mobile/features/deadline/domain/entities/deadline_entity.dart';
import 'package:uit_buddy_mobile/features/deadline/domain/repositories/deadline_repository.dart';

class GetDeadlinesUsecase implements UseCase<DeadlineDataEntity, void> {
  final DeadlineRepository repository;

  GetDeadlinesUsecase(this.repository);

  @override
  Future<Either<Failure, DeadlineDataEntity>> call(void params) async {
    return await repository.getDeadlines();
  }
}

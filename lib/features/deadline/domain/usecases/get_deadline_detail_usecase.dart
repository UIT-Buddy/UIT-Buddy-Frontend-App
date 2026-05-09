import 'package:fpdart/fpdart.dart';
import 'package:uit_buddy_mobile/core/error/failures.dart';
import 'package:uit_buddy_mobile/core/usecase/usecase_interface.dart';
import 'package:uit_buddy_mobile/features/deadline/domain/entities/deadline_entity.dart';
import 'package:uit_buddy_mobile/features/deadline/domain/repositories/deadline_repository.dart';

class GetDeadlineDetailUsecase implements UseCase<DeadlineEntity, String> {
  final DeadlineRepository repository;

  GetDeadlineDetailUsecase(this.repository);

  @override
  Future<Either<Failure, DeadlineEntity>> call(String params) async {
    return await repository.getDeadlineDetail(params);
  }
}

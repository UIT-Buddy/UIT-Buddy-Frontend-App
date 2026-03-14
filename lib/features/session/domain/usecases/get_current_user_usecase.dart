import 'package:fpdart/fpdart.dart';
import 'package:uit_buddy_mobile/core/error/failures.dart';
import 'package:uit_buddy_mobile/core/usecase/usecase_interface.dart';
import 'package:uit_buddy_mobile/features/session/domain/entities/user_entity.dart';
import 'package:uit_buddy_mobile/features/session/domain/repositories/session_repository.dart';

class GetCurrentUserUsecase implements UseCase<UserEntity, NoParams> {
  GetCurrentUserUsecase({required SessionRepository repository})
    : _repository = repository;

  final SessionRepository _repository;

  @override
  Future<Either<Failure, UserEntity>> call(NoParams params) =>
      _repository.getCurrentUser();
}

import 'package:fpdart/fpdart.dart';
import 'package:uit_buddy_mobile/core/error/failures.dart';
import 'package:uit_buddy_mobile/core/usecase/usecase_interface.dart';
import 'package:uit_buddy_mobile/features/social/domain/entities/comet_user_entity.dart';
import 'package:uit_buddy_mobile/features/social/domain/repositories/user_search_repository.dart';

class GetFriendUsersUsecase
    implements UseCase<List<CometUserEntity>, NoParams> {
  GetFriendUsersUsecase({required UserSearchRepository repository})
    : _repository = repository;

  final UserSearchRepository _repository;

  @override
  Future<Either<Failure, List<CometUserEntity>>> call(NoParams params) =>
      _repository.getFriendUsers();
}

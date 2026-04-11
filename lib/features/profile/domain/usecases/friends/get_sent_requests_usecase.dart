import 'package:fpdart/fpdart.dart';
import 'package:uit_buddy_mobile/core/common/paged_result.dart';
import 'package:uit_buddy_mobile/core/error/failures.dart';
import 'package:uit_buddy_mobile/core/usecase/usecase_interface.dart';
import 'package:uit_buddy_mobile/features/profile/domain/entities/cursor_params.dart';
import 'package:uit_buddy_mobile/features/profile/domain/entities/friend_entity.dart';
import 'package:uit_buddy_mobile/features/profile/domain/repositories/friend_repository.dart';

class GetSentRequestsUsecase
    implements UseCase<PagedResult<FriendEntity>, CursorParams> {
  GetSentRequestsUsecase({required FriendRepository friendRepository})
    : _friendRepository = friendRepository;

  final FriendRepository _friendRepository;

  @override
  Future<Either<Failure, PagedResult<FriendEntity>>> call(
    CursorParams params,
  ) async => _friendRepository.getSentFriendRequests(
    cursor: params.cursor,
    limit: params.limit,
  );
}

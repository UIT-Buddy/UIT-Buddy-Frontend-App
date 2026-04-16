import 'package:fpdart/fpdart.dart';
import 'package:uit_buddy_mobile/core/common/paged_result.dart';
import 'package:uit_buddy_mobile/core/error/failures.dart';
import 'package:uit_buddy_mobile/core/usecase/usecase_interface.dart';
import 'package:uit_buddy_mobile/features/storage/domain/entities/storage_cursor_params.dart';
import 'package:uit_buddy_mobile/features/storage/domain/entities/storage_friend_entity.dart';
import 'package:uit_buddy_mobile/features/storage/domain/repositories/storage_friend_repository.dart';

class StorageGetFriendsUsecase
    implements UseCase<PagedResult<StorageFriendEntity>, StorageCursorParams> {
  StorageGetFriendsUsecase({required StorageFriendRepository friendRepository})
    : _friendRepository = friendRepository;

  final StorageFriendRepository _friendRepository;

  @override
  Future<Either<Failure, PagedResult<StorageFriendEntity>>> call(
    StorageCursorParams params,
  ) async =>
      _friendRepository.getFriends(cursor: params.cursor, limit: params.limit);
}

import 'package:fpdart/fpdart.dart';
import 'package:uit_buddy_mobile/core/common/paged_result.dart';
import 'package:uit_buddy_mobile/core/error/failures.dart';
import 'package:uit_buddy_mobile/features/storage/domain/entities/storage_friend_entity.dart';

abstract interface class StorageFriendRepository {
  Future<Either<Failure, PagedResult<StorageFriendEntity>>> getFriends({
    String? cursor,
    int limit = 10,
  });
}

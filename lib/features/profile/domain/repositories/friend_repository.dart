import 'package:fpdart/fpdart.dart';
import 'package:uit_buddy_mobile/core/common/paged_result.dart';
import 'package:uit_buddy_mobile/core/error/failures.dart';
import 'package:uit_buddy_mobile/features/profile/domain/entities/friend_entity.dart';

abstract interface class FriendRepository {
  Future<Either<Failure, Unit>> respondToFriendRequest({
    required String senderMssv,
    required String action
  });

  Future<Either<Failure, Unit>> toggleFriendRequest({
    required String receiverMssv
  });

  Future<Either<Failure, PagedResult<FriendEntity>>> getFriends({
    String? cursor,
    int limit = 10
  });

  Future<Either<Failure, PagedResult<FriendEntity>>> getSentFriendRequests({
    String? cursor,
    int limit = 10
  });

  Future<Either<Failure, PagedResult<FriendEntity>>> getPendingFriendRequests({
    String? cursor,
    int limit = 10
  });

  Future<Either<Failure, Unit>> unFriend({
    required String friendMssv
  });
}
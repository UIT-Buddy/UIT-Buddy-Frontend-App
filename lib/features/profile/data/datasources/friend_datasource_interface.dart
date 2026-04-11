import 'package:uit_buddy_mobile/core/common/paged_result.dart';
import 'package:uit_buddy_mobile/features/profile/data/models/friend_model.dart';

abstract interface class FriendDatasourceInterface {
  Future<PagedResult<FriendModel>> getFriends({String? cursor, int limit = 10});

  Future<PagedResult<FriendModel>> getSentFriendRequests({
    String? cursor,
    int limit = 10,
  });

  Future<PagedResult<FriendModel>> getPendingFriendRequests({
    String? cursor,
    int limit = 10,
  });

  Future<void> unFriend(String friendMssv);

  Future<void> toggleFriendRequest(String receiverMssv);

  Future<void> respondToFriendRequest({
    required String action,
    required String senderMssv,
  });
}

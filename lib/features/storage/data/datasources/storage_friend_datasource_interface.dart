import 'package:uit_buddy_mobile/core/common/paged_result.dart';
import 'package:uit_buddy_mobile/features/storage/data/models/storage_friend_model.dart';

abstract interface class StorageFriendDatasourceInterface {
  Future<PagedResult<StorageFriendModel>> getFriends({
    String? cursor,
    int limit = 10,
  });
}

import 'package:uit_buddy_mobile/core/common/paged_result.dart';
import 'package:uit_buddy_mobile/features/social/data/models/search_user_model.dart';

abstract interface class UserSearchDatasourceInterface {
  Future<PagedResult<SearchUserModel>> searchUsers({
    required String keyword,
    int page = 1,
    int limit = 10,
    String? sortBy,
    String? sortType,
  });
}

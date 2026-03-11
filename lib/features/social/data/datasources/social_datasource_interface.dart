import 'package:uit_buddy_mobile/core/common/paged_result.dart';
import 'package:uit_buddy_mobile/features/social/data/models/post_model.dart';

abstract interface class SocialDatasourceInterface {
  Future<PagedResult<PostModel>> getPosts({String? cursor, int limit = 10});
}

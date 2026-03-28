import 'package:uit_buddy_mobile/core/common/paged_result.dart';
import 'package:uit_buddy_mobile/features/profile/data/models/your_post_model.dart';

abstract interface class ProfilePostDatasourceInterface {
  Future<PagedResult<YourPostModel>> getPosts({String? cursor, int limit = 10});

  Future<void> deletePost(String postId);

  Future<void> togglePostLike(String postId);
}

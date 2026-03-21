import 'package:uit_buddy_mobile/core/network/api/api_response.dart';
import 'package:uit_buddy_mobile/features/profile/data/models/post_model.dart';

abstract interface class ProfilePostDatasourceInterface {
  Future<ApiResponse<List<PostModel>>> getPosts();
}
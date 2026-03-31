import 'package:image_picker/image_picker.dart';
import 'package:uit_buddy_mobile/core/common/paged_result.dart';
import 'package:uit_buddy_mobile/features/social/data/models/post_model.dart';
import 'package:uit_buddy_mobile/features/social/data/models/search_post_model.dart';

abstract interface class PostDatasourceInterface {
  Future<PagedResult<PostModel>> getPosts({String? cursor, int limit = 10});

  Future<PagedResult<PostModel>> getPostsByUser({
    required String mssv,
    int page = 1,
    int limit = 10,
  });

  Future<PagedResult<SearchPostModel>> searchPosts({
    required String keyword,
    int page = 1,
    int limit = 10,
    String? sortBy,
    String? sortType,
  });

  Future<void> createPost({
    required String title,
    String? content,
    List<XFile> images = const [],
    List<XFile> videos = const [],
  });

  Future<void> deletePost(String postId);

  Future<PostModel> getPostDetail(String postId);

  Future<void> updatePost({
    required String postId,
    required String title,
    String? content,
  });
}

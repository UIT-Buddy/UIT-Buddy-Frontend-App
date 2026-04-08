import 'package:dio/dio.dart';
import 'package:uit_buddy_mobile/core/common/paged_result.dart';
import 'package:uit_buddy_mobile/features/profile/data/datasources/post_datasource_interface.dart';
import 'package:uit_buddy_mobile/features/profile/data/models/your_post_model.dart';
import 'package:uit_buddy_mobile/features/profile/data/datasources/impl/paging_mixin.dart';

class ProfilePostDatasourceImpl
    with PagingMixin
    implements ProfilePostDatasourceInterface {
  ProfilePostDatasourceImpl({required Dio dio}) : _dio = dio;

  final Dio _dio;

  @override
  Future<PagedResult<YourPostModel>> getPosts({
    String? cursor,
    int limit = 10,
  }) async {
    final queryParams = <String, dynamic>{'limit': limit};
    if (cursor != null) queryParams['cursor'] = cursor;

    final apiResponse = await _dio.get<Map<String, dynamic>>(
      '/api/posts/me',
      queryParameters: queryParams,
    );

    final body = apiResponse.data!;
    final dataList = (body['data'] as List)
        .map((e) => YourPostModel.fromJson(e as Map<String, dynamic>))
        .toList();

    return PagedResult<YourPostModel>(
      items: dataList,
      nextCursor: extractNextCursor(body),
      hasMore: extractHasMore(body, dataList.length, limit),
    );
  }

  @override
  Future<void> deletePost(String postId) async {
    await _dio.delete<void>('/api/posts/$postId');
  }

  @override
  Future<void> togglePostLike(String postId) async {
    await _dio.post<void>('/api/reactions/posts/$postId/like');
  }
}

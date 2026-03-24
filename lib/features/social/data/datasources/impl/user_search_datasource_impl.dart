import 'package:dio/dio.dart';
import 'package:uit_buddy_mobile/core/common/paged_result.dart';
import 'package:uit_buddy_mobile/features/social/data/datasources/impl/social_paging_mixin.dart';
import 'package:uit_buddy_mobile/features/social/data/datasources/user_search_datasource_interface.dart';
import 'package:uit_buddy_mobile/features/social/data/models/search_user_model.dart';

class UserSearchDatasourceImpl
    with SocialPagingMixin
    implements UserSearchDatasourceInterface {
  UserSearchDatasourceImpl({required Dio dio}) : _dio = dio;

  final Dio _dio;

  @override
  Future<PagedResult<SearchUserModel>> searchUsers({
    required String keyword,
    int page = 1,
    int limit = 10,
    String? sortBy,
    String? sortType,
  }) async {
    final queryParameters = <String, dynamic>{
      'keyword': keyword,
      'page': page,
      'limit': limit,
    };
    if (sortBy != null && sortBy.isNotEmpty) queryParameters['sortBy'] = sortBy;
    if (sortType != null && sortType.isNotEmpty) {
      queryParameters['sortType'] = sortType;
    }

    final response = await _dio.get<Map<String, dynamic>>(
      '/api/user/search',
      queryParameters: queryParameters,
    );

    final body = response.data!;
    final dataList = (body['data'] as List<dynamic>? ?? const [])
        .whereType<Map<String, dynamic>>()
        .map(SearchUserModel.fromJson)
        .toList();

    return PagedResult<SearchUserModel>(
      items: dataList,
      nextCursor: extractNextCursor(body),
      hasMore: extractHasMore(body, dataList.length, limit),
    );
  }
}

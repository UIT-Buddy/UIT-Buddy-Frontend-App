import 'package:dio/dio.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uit_buddy_mobile/core/common/paged_result.dart';
import 'package:uit_buddy_mobile/features/social/data/datasources/social_datasource_interface.dart';
import 'package:uit_buddy_mobile/features/social/data/models/post_model.dart';

class SocialDatasourceImpl implements SocialDatasourceInterface {
  SocialDatasourceImpl({required Dio dio}) : _dio = dio;

  final Dio _dio;

  @override
  Future<PagedResult<PostModel>> getPosts({
    String? cursor,
    int limit = 10,
  }) async {
    final queryParams = <String, dynamic>{'limit': limit};
    if (cursor != null) queryParams['cursor'] = cursor;

    final response = await _dio.get<Map<String, dynamic>>(
      '/api/posts',
      queryParameters: queryParams,
    );

    final body = response.data!;
    final dataList = (body['data'] as List)
        .map((e) => PostModel.fromJson(e as Map<String, dynamic>))
        .toList();

    final paging = body['paging'] as Map<String, dynamic>?;
    final nextCursor = paging?['nextCursor'] as String?;
    final hasMore = (paging?['hasMore'] as bool?) ?? false;

    return PagedResult<PostModel>(
      items: dataList,
      nextCursor: nextCursor,
      hasMore: hasMore,
    );
  }

  @override
  Future<PostModel> createPost({
    required String title,
    String? content,
    List<XFile> images = const [],
    List<XFile> videos = const [],
  }) async {
    final formData = FormData();
    formData.fields.add(MapEntry('title', title));
    if (content != null && content.isNotEmpty) {
      formData.fields.add(MapEntry('content', content));
    }
    for (final img in images) {
      formData.files.add(
        MapEntry(
          'images',
          await MultipartFile.fromFile(img.path, filename: img.name),
        ),
      );
    }
    for (final vid in videos) {
      formData.files.add(
        MapEntry(
          'videos',
          await MultipartFile.fromFile(vid.path, filename: vid.name),
        ),
      );
    }

    final response = await _dio.post<Map<String, dynamic>>(
      '/api/posts',
      data: formData,
    );

    return PostModel.fromJson(
      response.data!['data'] as Map<String, dynamic>,
    );
  }
}

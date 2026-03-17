import 'package:dio/dio.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uit_buddy_mobile/core/common/paged_result.dart';
import 'package:uit_buddy_mobile/features/social/data/datasources/social_datasource_interface.dart';
import 'package:uit_buddy_mobile/features/social/data/models/comment_model.dart';
import 'package:uit_buddy_mobile/features/social/data/models/post_model.dart';

class SocialDatasourceImpl implements SocialDatasourceInterface {
  SocialDatasourceImpl({required Dio dio}) : _dio = dio;

  final Dio _dio;

  // ─── Posts ─────────────────────────────────────────────────────────────────

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

    return PagedResult<PostModel>(
      items: dataList,
      nextCursor: _extractNextCursor(body),
      hasMore: _extractHasMore(body, dataList.length, limit),
    );
  }

  @override
  Future<void> createPost({
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

   await _dio.post<Map<String, dynamic>>(
      '/api/posts',
      data: formData,
    );

    
  }

  @override
  Future<void> deletePost(String postId) async {
    await _dio.delete<void>('/api/posts/$postId');
  }

  @override
  Future<void> toggleLike(String postId) async {
    await _dio.post<void>('/api/reactions/posts/$postId/like');
  }

  @override
  Future<PostModel> getPostDetail(String postId) async {
    final response = await _dio.get<Map<String, dynamic>>(
      '/api/posts/$postId',
    );
    return PostModel.fromJson(
      response.data!['data'] as Map<String, dynamic>,
    );
  }

  // ─── Comments ──────────────────────────────────────────────────────────────

  @override
  Future<PagedResult<CommentModel>> getPostComments({
    required String postId,
    String? cursor,
    int limit = 10,
  }) async {
    final queryParams = <String, dynamic>{'limit': limit};
    if (cursor != null) queryParams['cursor'] = cursor;

    final response = await _dio.get<Map<String, dynamic>>(
      '/api/comments/$postId/comments',
      queryParameters: queryParams,
    );

    final body = response.data!;
    final dataList = (body['data'] as List)
        .map((e) => CommentModel.fromJson(e as Map<String, dynamic>))
        .toList();

    return PagedResult<CommentModel>(
      items: dataList,
      nextCursor: _extractNextCursor(body),
      hasMore: _extractHasMore(body, dataList.length, limit),
    );
  }

  @override
  Future<void> createComment({
    required String postId,
    required String content,
  }) async {
    await _dio.post<void>(
      '/api/comments/$postId',
      data: {'content': content},
    );
  }

  @override
  Future<void> replyToComment({
    required String commentId,
    required String content,
  }) async {
    await _dio.post<void>(
      '/api/comments/$commentId/replies',
      data: {'content': content},
    );
  }

  @override
  Future<void> updateComment({
    required String commentId,
    required String content,
  }) async {
    await _dio.put<void>(
      '/api/comments/$commentId',
      data: {'content': content},
    );
  }

  @override
  Future<PagedResult<CommentModel>> getCommentReplies({
    required String commentId,
    String? cursor,
    int limit = 5,
  }) async {
    final queryParams = <String, dynamic>{'limit': limit};
    if (cursor != null) queryParams['cursor'] = cursor;

    final response = await _dio.get<Map<String, dynamic>>(
      '/api/comments/comments/$commentId/replies',
      queryParameters: queryParams,
    );

    final body = response.data!;
    final dataList = (body['data'] as List)
        .map((e) => CommentModel.fromJson(e as Map<String, dynamic>))
        .toList();

    return PagedResult<CommentModel>(
      items: dataList,
      nextCursor: _extractNextCursor(body),
      hasMore: _extractHasMore(body, dataList.length, limit),
    );
  }

  @override
  Future<void> deleteComment(String commentId) async {
    await _dio.delete<void>('/api/comments/$commentId');
  }

  @override
  Future<void> toggleCommentLike(String commentId) async {
    await _dio.post<void>('/api/comments/$commentId/like');
  }

  // ─── Paging helpers ────────────────────────────────────────────────────────

  String? _extractNextCursor(Map<String, dynamic> body) {
    final paging = body['paging'] as Map<String, dynamic>?;
    return paging?['nextCursor'] as String?;
  }

  /// Handles both cursor-based (`hasMore`) and offset-based (`page`/`totalPages`) paging.
  bool _extractHasMore(
    Map<String, dynamic> body,
    int returnedCount,
    int requestedLimit,
  ) {
    final paging = body['paging'] as Map<String, dynamic>?;
    if (paging == null) return false;

    if (paging.containsKey('hasMore')) {
      return (paging['hasMore'] as bool?) ?? false;
    }
    if (paging.containsKey('page') && paging.containsKey('totalPages')) {
      return (paging['page'] as int) < (paging['totalPages'] as int);
    }
    return returnedCount == requestedLimit;
  }
}

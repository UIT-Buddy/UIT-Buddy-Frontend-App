import 'package:dio/dio.dart';
import 'package:uit_buddy_mobile/core/common/paged_result.dart';
import 'package:uit_buddy_mobile/features/social/data/datasources/comment_datasource_interface.dart';
import 'package:uit_buddy_mobile/features/social/data/datasources/impl/social_paging_mixin.dart';
import 'package:uit_buddy_mobile/features/social/data/models/comment_model.dart';

class CommentDatasourceImpl
    with SocialPagingMixin
    implements CommentDatasourceInterface {
  CommentDatasourceImpl({required Dio dio}) : _dio = dio;

  final Dio _dio;

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
      nextCursor: extractNextCursor(body),
      hasMore: extractHasMore(body, dataList.length, limit),
    );
  }

  @override
  Future<void> createComment({
    required String postId,
    required String content,
  }) async {
    await _dio.post<void>('/api/comments/$postId', data: {'content': content});
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
      nextCursor: extractNextCursor(body),
      hasMore: extractHasMore(body, dataList.length, limit),
    );
  }

  @override
  Future<void> deleteComment(String commentId) async {
    await _dio.delete<void>('/api/comments/$commentId');
  }
}

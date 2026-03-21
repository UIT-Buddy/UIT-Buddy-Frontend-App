import 'package:dio/dio.dart';
import 'package:uit_buddy_mobile/features/social/data/datasources/reaction_datasource_interface.dart';

class ReactionDatasourceImpl implements ReactionDatasourceInterface {
  ReactionDatasourceImpl({required Dio dio}) : _dio = dio;

  final Dio _dio;

  @override
  Future<void> togglePostLike(String postId) async {
    await _dio.post<void>('/api/reactions/posts/$postId/like');
  }

  @override
  Future<void> toggleCommentLike(String commentId) async {
    await _dio.post<void>('/api/comments/$commentId/like');
  }
}

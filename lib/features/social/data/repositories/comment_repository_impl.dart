import 'package:fpdart/fpdart.dart';
import 'package:uit_buddy_mobile/core/common/paged_result.dart';
import 'package:uit_buddy_mobile/core/error/failures.dart';
import 'package:uit_buddy_mobile/features/social/data/datasources/comment_datasource_interface.dart';
import 'package:uit_buddy_mobile/features/social/data/mapper/comment_mapper.dart';
import 'package:uit_buddy_mobile/features/social/domain/entities/comment_entity.dart';
import 'package:uit_buddy_mobile/features/social/domain/repositories/comment_repository.dart';

class CommentRepositoryImpl implements CommentRepository {
  CommentRepositoryImpl({required CommentDatasourceInterface datasource})
    : _datasource = datasource;

  final CommentDatasourceInterface _datasource;

  @override
  Future<Either<Failure, PagedResult<CommentEntity>>> getPostComments({
    required String postId,
    String? cursor,
    int limit = 10,
  }) async {
    try {
      final result = await _datasource.getPostComments(
        postId: postId,
        cursor: cursor,
        limit: limit,
      );
      return Right(
        PagedResult<CommentEntity>(
          items: result.items.map((m) => m.toEntity()).toList(),
          nextCursor: result.nextCursor,
          hasMore: result.hasMore,
        ),
      );
    } on Exception catch (e) {
      return Left(Failure.fromException(e));
    }
  }

  @override
  Future<Either<Failure, Unit>> createComment({
    required String postId,
    required String content,
  }) async {
    try {
      await _datasource.createComment(postId: postId, content: content);
      return const Right(unit);
    } on Exception catch (e) {
      return Left(Failure.fromException(e));
    }
  }

  @override
  Future<Either<Failure, Unit>> replyToComment({
    required String commentId,
    required String content,
  }) async {
    try {
      await _datasource.replyToComment(commentId: commentId, content: content);
      return const Right(unit);
    } on Exception catch (e) {
      return Left(Failure.fromException(e));
    }
  }

  @override
  Future<Either<Failure, Unit>> updateComment({
    required String commentId,
    required String content,
  }) async {
    try {
      await _datasource.updateComment(commentId: commentId, content: content);
      return const Right(unit);
    } on Exception catch (e) {
      return Left(Failure.fromException(e));
    }
  }

  @override
  Future<Either<Failure, PagedResult<CommentEntity>>> getCommentReplies({
    required String commentId,
    String? cursor,
    int limit = 5,
  }) async {
    try {
      final result = await _datasource.getCommentReplies(
        commentId: commentId,
        cursor: cursor,
        limit: limit,
      );
      return Right(
        PagedResult<CommentEntity>(
          items: result.items.map((m) => m.toEntity()).toList(),
          nextCursor: result.nextCursor,
          hasMore: result.hasMore,
        ),
      );
    } on Exception catch (e) {
      return Left(Failure.fromException(e));
    }
  }

  @override
  Future<Either<Failure, Unit>> deleteComment(String commentId) async {
    try {
      await _datasource.deleteComment(commentId);
      return const Right(unit);
    } on Exception catch (e) {
      return Left(Failure.fromException(e));
    }
  }
}

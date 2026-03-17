import 'package:fpdart/fpdart.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uit_buddy_mobile/core/common/paged_result.dart';
import 'package:uit_buddy_mobile/core/error/failures.dart';
import 'package:uit_buddy_mobile/features/social/data/datasources/social_datasource_interface.dart';
import 'package:uit_buddy_mobile/features/social/data/mapper/comment_mapper.dart';
import 'package:uit_buddy_mobile/features/social/data/mapper/post_mapper.dart';
import 'package:uit_buddy_mobile/features/social/domain/entities/comment_entity.dart';
import 'package:uit_buddy_mobile/features/social/domain/entities/post_entity.dart';
import 'package:uit_buddy_mobile/features/social/domain/repositories/social_repository.dart';

class SocialRepositoryImpl implements SocialRepository {
  SocialRepositoryImpl({required SocialDatasourceInterface datasource})
    : _datasource = datasource;

  final SocialDatasourceInterface _datasource;

  // ─── Posts ─────────────────────────────────────────────────────────────────

  @override
  Future<Either<Failure, PagedResult<PostEntity>>> getPosts({
    String? cursor,
    int limit = 10,
  }) async {
    try {
      final result = await _datasource.getPosts(cursor: cursor, limit: limit);
      return Right(
        PagedResult<PostEntity>(
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
    Future<Either<Failure, Unit>> createPost({
    required String title,
    String? content,
    List<XFile> images = const [],
    List<XFile> videos = const [],
  }) async {
    try {
      await _datasource.createPost(
        title: title,
        content: content,
        images: images,
        videos: videos,
      );
      return const Right(unit);
    } on Exception catch (e) {
      return Left(Failure.fromException(e));
    }
  }

  @override
  Future<Either<Failure, Unit>> deletePost(String postId) async {
    try {
      await _datasource.deletePost(postId);
      return const Right(unit);
    } on Exception catch (e) {
      return Left(Failure.fromException(e));
    }
  }

  @override
  Future<Either<Failure, Unit>> toggleLike(String postId) async {
    try {
      await _datasource.toggleLike(postId);
      return const Right(unit);
    } on Exception catch (e) {
      return Left(Failure.fromException(e));
    }
  }

  @override
  Future<Either<Failure, PostEntity>> getPostDetail(String postId) async {
    try {
      final model = await _datasource.getPostDetail(postId);
      return Right(model.toEntity());
    } on Exception catch (e) {
      return Left(Failure.fromException(e));
    }
  }

  // ─── Comments ──────────────────────────────────────────────────────────────

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
      await _datasource.replyToComment(
        commentId: commentId,
        content: content,
      );
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
      await _datasource.updateComment(
        commentId: commentId,
        content: content,
      );
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

  @override
  Future<Either<Failure, Unit>> toggleCommentLike(String commentId) async {
    try {
      await _datasource.toggleCommentLike(commentId);
      return const Right(unit);
    } on Exception catch (e) {
      return Left(Failure.fromException(e));
    }
  }
}

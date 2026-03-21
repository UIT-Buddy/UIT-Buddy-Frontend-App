import 'package:fpdart/fpdart.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uit_buddy_mobile/core/common/paged_result.dart';
import 'package:uit_buddy_mobile/core/error/failures.dart';
import 'package:uit_buddy_mobile/features/social/data/datasources/post_datasource_interface.dart';
import 'package:uit_buddy_mobile/features/social/data/mapper/post_mapper.dart';
import 'package:uit_buddy_mobile/features/social/domain/entities/post_entity.dart';
import 'package:uit_buddy_mobile/features/social/domain/repositories/post_repository.dart';

class PostRepositoryImpl implements PostRepository {
  PostRepositoryImpl({required PostDatasourceInterface datasource})
    : _datasource = datasource;

  final PostDatasourceInterface _datasource;

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
  Future<Either<Failure, PostEntity>> getPostDetail(String postId) async {
    try {
      final model = await _datasource.getPostDetail(postId);
      return Right(model.toEntity());
    } on Exception catch (e) {
      return Left(Failure.fromException(e));
    }
  }

  @override
  Future<Either<Failure, Unit>> updatePost({
    required String postId,
    required String title,
    String? content,
  }) async {
    try {
      await _datasource.updatePost(
        postId: postId,
        title: title,
        content: content,
      );
      return const Right(unit);
    } on Exception catch (e) {
      return Left(Failure.fromException(e));
    }
  }
}

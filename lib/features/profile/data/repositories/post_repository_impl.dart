import 'package:fpdart/fpdart.dart';
import 'package:uit_buddy_mobile/core/common/paged_result.dart';
import 'package:uit_buddy_mobile/core/error/failures.dart';
import 'package:uit_buddy_mobile/features/profile/data/datasources/post_datasource_interface.dart';
import 'package:uit_buddy_mobile/features/profile/data/mapper/your_post_mapper.dart';
import 'package:uit_buddy_mobile/features/profile/domain/entities/post_entity.dart';
import 'package:uit_buddy_mobile/features/profile/domain/repositories/post_repository.dart';

class ProfilePostRepositoryImpl implements ProfilePostRepository {
  ProfilePostRepositoryImpl({
    required ProfilePostDatasourceInterface postDatasourceInterface,
  }) : _postDatasource = postDatasourceInterface;

  final ProfilePostDatasourceInterface _postDatasource;

  @override
  Future<Either<Failure, PagedResult<PostEntity>>> getPosts({
    String? cursor,
    int limit = 10,
  }) async {
    try {
      final response = await _postDatasource.getPosts(
        cursor: cursor,
        limit: limit,
      );

      return Right(
        PagedResult<PostEntity>(
          items: response.items.map((m) => m.toEntity()).toList(),
          nextCursor: response.nextCursor,
          hasMore: response.hasMore,
        ),
      );
    } on Exception catch (e) {
      return Left(Failure.fromException(e));
    }
  }

  @override
  Future<Either<Failure, Unit>> deletePost(String postId) async {
    try {
      await _postDatasource.deletePost(postId);
      return const Right(unit);
    } on Exception catch (e) {
      return Left(Failure.fromException(e));
    }
  }

  @override
  Future<Either<Failure, Unit>> togglePostLike(String postId) async {
    try {
      await _postDatasource.togglePostLike(postId);
      return const Right(unit);
    } on Exception catch (e) {
      return Left(Failure.fromException(e));
    }
  }
}

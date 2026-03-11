import 'package:fpdart/fpdart.dart';
import 'package:uit_buddy_mobile/core/common/paged_result.dart';
import 'package:uit_buddy_mobile/core/error/failures.dart';
import 'package:uit_buddy_mobile/features/social/data/datasources/social_datasource_interface.dart';
import 'package:uit_buddy_mobile/features/social/data/mapper/post_mapper.dart';
import 'package:uit_buddy_mobile/features/social/domain/entities/post_entity.dart';
import 'package:uit_buddy_mobile/features/social/domain/repositories/social_repository.dart';

class SocialRepositoryImpl implements SocialRepository {
  SocialRepositoryImpl({required SocialDatasourceInterface datasource})
    : _datasource = datasource;

  final SocialDatasourceInterface _datasource;

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
}

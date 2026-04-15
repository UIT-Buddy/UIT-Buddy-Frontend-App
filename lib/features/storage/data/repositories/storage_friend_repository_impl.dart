import 'package:fpdart/fpdart.dart';
import 'package:uit_buddy_mobile/core/common/paged_result.dart';
import 'package:uit_buddy_mobile/core/error/failures.dart';
import 'package:uit_buddy_mobile/features/storage/data/datasources/storage_friend_datasource_interface.dart';
import 'package:uit_buddy_mobile/features/storage/data/mapper/storage_friend_mapper.dart';
import 'package:uit_buddy_mobile/features/storage/domain/entities/storage_friend_entity.dart';
import 'package:uit_buddy_mobile/features/storage/domain/repositories/storage_friend_repository.dart';

class StorageFriendRepositoryImpl implements StorageFriendRepository {
  StorageFriendRepositoryImpl({
    required StorageFriendDatasourceInterface storageFriendDatasourceInterface,
  }) : _storageFriendDatasourceInterface = storageFriendDatasourceInterface;

  final StorageFriendDatasourceInterface _storageFriendDatasourceInterface;

  @override
  Future<Either<Failure, PagedResult<StorageFriendEntity>>> getFriends({
    String? cursor,
    int limit = 10,
  }) async {
    try {
      final response = await _storageFriendDatasourceInterface.getFriends(
        cursor: cursor,
        limit: limit,
      );

      return Right(
        PagedResult<StorageFriendEntity>(
          items: response.items.map((m) => m.toEntity()).toList(),
          nextCursor: response.nextCursor,
          hasMore: response.hasMore,
        ),
      );
    } on Exception catch (e) {
      return Left(Failure.fromException(e));
    }
  }
}

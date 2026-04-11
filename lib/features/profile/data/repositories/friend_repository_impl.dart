import 'package:fpdart/fpdart.dart';
import 'package:uit_buddy_mobile/core/common/paged_result.dart';
import 'package:uit_buddy_mobile/core/error/failures.dart';
import 'package:uit_buddy_mobile/features/profile/data/datasources/friend_datasource_interface.dart';
import 'package:uit_buddy_mobile/features/profile/data/mapper/friend_mapper.dart';
import 'package:uit_buddy_mobile/features/profile/domain/entities/friend_entity.dart';
import 'package:uit_buddy_mobile/features/profile/domain/repositories/friend_repository.dart';

class FriendRepositoryImpl implements FriendRepository {
  FriendRepositoryImpl({
    required FriendDatasourceInterface friendDatasourceInterface,
  }) : _friendDatasourceInterface = friendDatasourceInterface;

  final FriendDatasourceInterface _friendDatasourceInterface;

  @override
  Future<Either<Failure, PagedResult<FriendEntity>>> getFriends({
    String? cursor,
    int limit = 10,
  }) async {
    try {
      final response = await _friendDatasourceInterface.getFriends(
        cursor: cursor,
        limit: limit,
      );

      return Right(
        PagedResult<FriendEntity>(
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
  Future<Either<Failure, PagedResult<FriendEntity>>> getSentFriendRequests({
    String? cursor,
    int limit = 10,
  }) async {
    try {
      final response = await _friendDatasourceInterface.getSentFriendRequests(
        cursor: cursor,
        limit: limit,
      );

      return Right(
        PagedResult<FriendEntity>(
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
  Future<Either<Failure, PagedResult<FriendEntity>>> getPendingFriendRequests({
    String? cursor,
    int limit = 10,
  }) async {
    try {
      final response = await _friendDatasourceInterface
          .getPendingFriendRequests(cursor: cursor, limit: limit);

      return Right(
        PagedResult<FriendEntity>(
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
  Future<Either<Failure, Unit>> unFriend({required String friendMssv}) async {
    try {
      await _friendDatasourceInterface.unFriend(friendMssv);
      return const Right(unit);
    } on Exception catch (e) {
      return Left(Failure.fromException(e));
    }
  }

  @override
  Future<Either<Failure, Unit>> respondToFriendRequest({
    required String action,
    required String senderMssv,
  }) async {
    try {
      await _friendDatasourceInterface.respondToFriendRequest(
        action: action,
        senderMssv: senderMssv,
      );
      return const Right(unit);
    } on Exception catch (e) {
      return Left(Failure.fromException(e));
    }
  }

  @override
  Future<Either<Failure, Unit>> toggleFriendRequest({
    required String receiverMssv,
  }) async {
    try {
      await _friendDatasourceInterface.toggleFriendRequest(receiverMssv);
      return const Right(unit);
    } on Exception catch (e) {
      return Left(Failure.fromException(e));
    }
  }
}

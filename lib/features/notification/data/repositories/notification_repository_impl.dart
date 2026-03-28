import 'package:fpdart/fpdart.dart';
import 'package:uit_buddy_mobile/core/error/failures.dart';
import 'package:uit_buddy_mobile/features/notification/data/datasources/notification_datasource_interface.dart';
import 'package:uit_buddy_mobile/features/notification/data/mapper/notification_mapper.dart';
import 'package:uit_buddy_mobile/features/notification/domain/entities/notification_entity.dart';
import 'package:uit_buddy_mobile/features/notification/domain/repositories/notification_repository.dart';
import 'package:uit_buddy_mobile/core/common/paged_result.dart';

class NotificationRepositoryImpl implements NotificationRepository {
  NotificationRepositoryImpl({
    required NotificationDatasourceInterface notificationDatasourceInterface,
  }) : _notificationDatasourceInterface = notificationDatasourceInterface;

  final NotificationDatasourceInterface _notificationDatasourceInterface;

  @override
  Future<Either<Failure, PagedResult<NotificationEntity>>> getNotifications({
    String? cursor,
    int limit = 10,
  }) async {
    try {
      final apiResponse = await _notificationDatasourceInterface
          .getNotifications(cursor: cursor, limit: limit);

      return Right(
        PagedResult<NotificationEntity>(
          items: apiResponse.items.map((e) => e.toEntity()).toList(),
          nextCursor: apiResponse.nextCursor,
          hasMore: apiResponse.hasMore,
        ),
      );
    } on Exception catch (e) {
      return Left(Failure.fromException(e));
    }
  }

  @override
  Future<Either<Failure, Unit>> markNotificationAsRead(
    String notificationId,
  ) async {
    try {
      await _notificationDatasourceInterface.markNotificationAsRead(
        notificationId,
      );
      return const Right(unit);
    } on Exception catch (e) {
      return Left(Failure.fromException(e));
    }
  }

  @override
  Future<Either<Failure, Unit>> markAllNotificationsAsRead() async {
    try {
      await _notificationDatasourceInterface.markAllNotificationsAsRead();
      return const Right(unit);
    } on Exception catch (e) {
      return Left(Failure.fromException(e));
    }
  }

  @override
  Future<Either<Failure, int>> getUnreadCount() async {
    try {
      final res = await _notificationDatasourceInterface.getUnreadCount();
      return Right(res);
    } on Exception catch (e) {
      return Left(Failure.fromException(e));
    }
  }

  @override
  Future<Either<Failure, Unit>> deleteNotification(
    String notificationId,
  ) async {
    try {
      await _notificationDatasourceInterface.deleteNotification(notificationId);
      return const Right(unit);
    } on Exception catch (e) {
      return Left(Failure.fromException(e));
    }
  }
}

import 'package:fpdart/fpdart.dart';
import 'package:uit_buddy_mobile/core/error/failures.dart';
import 'package:uit_buddy_mobile/features/notification/domain/entities/notification_entity.dart';
import 'package:uit_buddy_mobile/core/common/paged_result.dart';

abstract interface class NotificationRepository {
  Future<Either<Failure, PagedResult<NotificationEntity>>> getNotifications({
    String? cursor,
    int limit = 10,
  });

  Future<Either<Failure, Unit>> markNotificationAsRead(String notificationId);

  Future<Either<Failure, Unit>> markAllNotificationsAsRead();

  Future<Either<Failure, int>> getUnreadCount();

  Future<Either<Failure, Unit>> deleteNotification(String notificationId);
}

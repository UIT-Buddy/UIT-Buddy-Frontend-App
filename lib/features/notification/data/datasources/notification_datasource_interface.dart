import 'package:uit_buddy_mobile/core/common/paged_result.dart';
import 'package:uit_buddy_mobile/features/notification/data/models/notification_model.dart';

abstract interface class NotificationDatasourceInterface {
  Future<PagedResult<NotificationModel>> getNotifications({String? cursor, int limit = 10});

  Future<void>markNotificationAsRead(String notificationId);

  Future<void>markAllNotificationsAsRead();

  Future<int>getUnreadCount();

  Future<void> deleteNotification(String notificationId);
}

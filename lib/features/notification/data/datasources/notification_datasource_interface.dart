import 'package:uit_buddy_mobile/core/network/api/api_response.dart';
import 'package:uit_buddy_mobile/features/notification/data/models/notification_model.dart';

abstract interface class NotificationDatasourceInterface {
  Future<ApiResponse<NotificationModel>> getNotifications();
}

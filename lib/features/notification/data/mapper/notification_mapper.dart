import 'package:uit_buddy_mobile/features/notification/data/models/notification_model.dart' as model;
import 'package:uit_buddy_mobile/features/notification/domain/entities/notification_entity.dart' as entity;

extension CalendarDeadlineItemMapper on model.NotificationItemModel {
  entity.NotificationItemEntity toEntity() =>
      entity.NotificationItemEntity(
        id: id,
        title: title,
        content: content,
        isRead: isRead,
        type: _mapType(type),
        redirectUrl: redirectUrl
      );

  entity.NotificationType _mapType(String type) {
    switch (type.toUpperCase()) {
      case 'SYSTEM':
        return entity.NotificationType.SYSTEM;
      case 'ACADEMIC':
        return entity.NotificationType.ACADEMIC;
      case 'REMINDER':
        return entity.NotificationType.REMINDER;
      case 'SOCIAL':
        return entity.NotificationType.SOCIAL;
      default:
        return entity.NotificationType.SYSTEM;
    }
  }
}

extension NotificationMapper on model.NotificationModel {
  entity.NotificationEntity toEntity() => entity.NotificationEntity(
    items: items.map((e) => e.toEntity()).toList(),
  );
}
import 'package:uit_buddy_mobile/features/notification/data/models/notification_model.dart'
    as model;
import 'package:uit_buddy_mobile/features/notification/domain/entities/notification_entity.dart'
    as entity;

extension NotificationMapper on model.NotificationModel {
  entity.NotificationEntity toEntity() => entity.NotificationEntity(
    id: id,
    title: title,
    content: content ?? '',
    isRead: isRead,
    type: _mapType(type),
    dataId: dataId,
    createdAt: createdAt
  );

  entity.NotificationType _mapType(String type) {
    switch (type.toUpperCase()) {
      case 'SYSTEM':
        return entity.NotificationType.system;
      case 'POST_LIKE':
        return entity.NotificationType.postLike;
      case 'POST_COMMENT':
        return entity.NotificationType.postComment;
      case 'POST_SHARE':
        return entity.NotificationType.postShare;
      case 'COMMENT_LIKE':
        return entity.NotificationType.commentLike;
      case 'FRIEND_REQUEST_RECEIVED':
        return entity.NotificationType.friendRequestReceived;
      case 'FRIEND_REQUEST_ACCEPTED':
        return entity.NotificationType.friendRequestAccepted;
      case 'ACADEMIC':
        return entity.NotificationType.academic;
      case 'REMINDER':
        return entity.NotificationType.reminder;
      default:
        return entity.NotificationType.system;
    }
  }
}
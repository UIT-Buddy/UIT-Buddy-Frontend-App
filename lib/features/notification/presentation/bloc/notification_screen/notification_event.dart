import 'package:equatable/equatable.dart';

abstract class NotificationEvent extends Equatable {
  const NotificationEvent();

  @override
  List<Object?> get props => [];
}

class NotificationsLoaded extends NotificationEvent {
  const NotificationsLoaded();
}

class NotificationRefreshed extends NotificationEvent {
  const NotificationRefreshed();
}

class NotificationLoadMore extends NotificationEvent {
  const NotificationLoadMore();
}

class NotificationGetUnreadCount extends NotificationEvent {
  const NotificationGetUnreadCount();
}

class NotificationMarkAsRead extends NotificationEvent {
  final String notificationId;
  const NotificationMarkAsRead({required this.notificationId});

  @override
  List<Object?> get props => [notificationId];
}

class NotificationDeleted extends NotificationEvent {
  final String notificationId;
  const NotificationDeleted({required this.notificationId});

  @override
  List<Object?> get props => [notificationId];
}

import 'package:equatable/equatable.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

@immutable
class NotificationEntity extends Equatable {
  final List<NotificationItemEntity> items;

  const NotificationEntity({
    required this.items
  });

  @override
  List<Object?> get props => [items];
}

enum NotificationType {
    SYSTEM,
    ACADEMIC,
    REMINDER,
    SOCIAL
}

@immutable
class NotificationItemEntity extends Equatable {
  final String id;
  final String title;
  final String content;
  final NotificationType type;
  final bool isRead;
  final String redirectUrl;

  const NotificationItemEntity({
    required this.id,
    required this.title,
    required this.content,
    required this.type,
    required this.isRead,
    required this.redirectUrl,
  });

  @override
  List<Object?> get props => [id, title, content, type, isRead, redirectUrl];
}
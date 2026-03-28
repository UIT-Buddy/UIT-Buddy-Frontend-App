import 'package:equatable/equatable.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

enum NotificationType {
  system,
  postLike,
  postComment,
  postShare,
  commentLike,
  friendRequestReceived,
  friendRequestAccepted,
  academic,
  reminder,
}

@immutable
class NotificationEntity extends Equatable {
  final String id;
  final String title;
  final String content;
  final NotificationType type;
  final bool isRead;
  final String dataId;
  final DateTime createdAt;
  //final String redirectUrl; maybe needed some day

  const NotificationEntity({
    required this.id,
    required this.title,
    required this.content,
    required this.type,
    required this.isRead,
    required this.dataId,
    required this.createdAt,
  });

  NotificationEntity copyWith({
    String? id,
    String? title,
    String? content,
    NotificationType? type,
    bool? isRead,
    String? dataId,
    DateTime? createdAt,
  }) {
    return NotificationEntity(
      id: id ?? this.id,
      title: title ?? this.title,
      content: content ?? this.content,
      type: type ?? this.type,
      isRead: isRead ?? this.isRead,
      dataId: dataId ?? this.dataId,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  List<Object?> get props => [
    id,
    title,
    content,
    type,
    isRead,
    dataId,
    createdAt,
  ];
}

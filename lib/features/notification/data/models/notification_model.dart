import 'package:equatable/equatable.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

@immutable
class NotificationModel extends Equatable {
  final List<NotificationItemModel> items;

  const NotificationModel({required this.items});

  @override
  List<Object?> get props => [items];
}

@immutable
class NotificationItemModel extends Equatable {
  final String id;
  final String title;
  final String content;
  final String type;
  final bool isRead;
  final String redirectUrl;

  const NotificationItemModel({
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

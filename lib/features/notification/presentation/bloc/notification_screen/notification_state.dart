import 'package:equatable/equatable.dart';
import 'package:uit_buddy_mobile/features/notification/domain/entities/notification_entity.dart';

enum NotificationStatus { initial, loading, loaded, error }

class NotificationState extends Equatable {
  const NotificationState({
    this.status = NotificationStatus.initial,
    this.notificationEntity,
    this.errorMessage,
  });

  final NotificationStatus status;
  final NotificationEntity? notificationEntity;
  final String? errorMessage;

  NotificationState copyWith({
    NotificationStatus? status,
    NotificationEntity? notificationEntity,
    String? errorMessage,
  }) {
    return NotificationState(
      status: status ?? this.status,
      notificationEntity: notificationEntity ?? this.notificationEntity,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, notificationEntity, errorMessage];
}

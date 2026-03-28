import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:uit_buddy_mobile/features/notification/domain/entities/notification_entity.dart';

part 'notification_state.freezed.dart';

enum NotificationStatus { initial, loading, loaded, error }

@freezed
abstract class NotificationState with _$NotificationState {
  const factory NotificationState({
    @Default(NotificationStatus.initial) NotificationStatus status,
    @Default([]) List<NotificationEntity> notifs,
    String? errorMessage,
    String? nextCursor,
    @Default(true) bool hasMore,
    @Default(false) bool isLoadingMore,
    @Default(false) bool isDeletingNotification,
    @Default(false) bool isMarkingAsRead,
  }) = _NotificationState;
}

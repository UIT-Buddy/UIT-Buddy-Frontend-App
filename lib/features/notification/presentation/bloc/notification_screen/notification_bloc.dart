import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uit_buddy_mobile/core/usecase/usecase_interface.dart';
import 'package:uit_buddy_mobile/features/notification/domain/usecases/delete_notification_usecase.dart';
import 'package:uit_buddy_mobile/features/notification/domain/usecases/get_notification_usecase.dart';
import 'package:uit_buddy_mobile/features/notification/domain/usecases/get_unread_count_usecase.dart';
import 'package:uit_buddy_mobile/features/notification/domain/usecases/mark_notification_read_usecase.dart';
import 'package:uit_buddy_mobile/features/notification/presentation/bloc/notification_screen/notification_event.dart';
import 'package:uit_buddy_mobile/features/notification/presentation/bloc/notification_screen/notification_state.dart';

class NotificationBloc extends Bloc<NotificationEvent, NotificationState> {
  NotificationBloc({
    required GetNotificationUsecase getNotificationUsecase,
    required MarkNotificationReadUsecase markNotificationReadUsecase,
    required GetUnreadCountUsecase getUnreadCountUsecase,
    required DeleteNotificationUsecase deleteNotificationUsecase,
  }) : _getNotificationUsecase = getNotificationUsecase,
       _markNotificationReadUsecase = markNotificationReadUsecase,
       _getUnreadCountUsecase = getUnreadCountUsecase,
       _deleteNotificationUsecase = deleteNotificationUsecase,
       super(const NotificationState()) {
    on<NotificationsLoaded>(_onNotificationLoaded);
    on<NotificationRefreshed>(_onNotificationRefreshed);
    on<NotificationLoadMore>(_onNotificationLoadMore);
    on<NotificationGetUnreadCount>(_onNotificationGetUnreadCount);
    on<NotificationMarkAsRead>(_onNotificationMarkAsRead);
    on<NotificationDeleted>(_onNotificationDeleted);
  }

  final GetNotificationUsecase _getNotificationUsecase;
  final MarkNotificationReadUsecase _markNotificationReadUsecase;
  final GetUnreadCountUsecase _getUnreadCountUsecase;
  final DeleteNotificationUsecase _deleteNotificationUsecase;

  Future<void> _onNotificationLoaded(
    NotificationsLoaded event,
    Emitter<NotificationState> emit,
  ) async {
    emit(state.copyWith(status: NotificationStatus.loading));

    final result = await _getNotificationUsecase(const NotificationParams());

    result.fold(
      (failure) => emit(
        state.copyWith(
          status: NotificationStatus.error,
          errorMessage: failure.message,
        ),
      ),
      (paged) => emit(
        state.copyWith(
          status: NotificationStatus.loaded,
          notifs: paged.items,
          nextCursor: paged.nextCursor,
          hasMore: paged.hasMore,
        ),
      ),
    );
  }

  Future<void> _onNotificationRefreshed(
    NotificationRefreshed event,
    Emitter<NotificationState> emit,
  ) async {
    emit(
      state.copyWith(
        status: NotificationStatus.loading,
        nextCursor: null,
        hasMore: true,
      ),
    );
    final result = await _getNotificationUsecase(const NotificationParams());
    result.fold(
      (failure) => emit(
        state.copyWith(
          status: NotificationStatus.error,
          errorMessage: failure.message,
        ),
      ),
      (paged) => emit(
        state.copyWith(
          status: NotificationStatus.loaded,
          notifs: paged.items,
          nextCursor: paged.nextCursor,
          hasMore: paged.hasMore,
        ),
      ),
    );
  }

  Future<void> _onNotificationLoadMore(
    NotificationLoadMore event,
    Emitter<NotificationState> emit,
  ) async {
    if (!state.hasMore || state.isLoadingMore) return;

    emit(state.copyWith(isLoadingMore: true));
    final result = await _getNotificationUsecase(
      NotificationParams(cursor: state.nextCursor),
    );
    result.fold((failure) => emit(state.copyWith(isLoadingMore: false)), (
      paged,
    ) {
      final allNotifs = [...state.notifs, ...paged.items];
      emit(
        state.copyWith(
          isLoadingMore: false,
          notifs: allNotifs,
          nextCursor: paged.nextCursor,
          hasMore: paged.hasMore,
        ),
      );
    });
  }

  Future<void> _onNotificationGetUnreadCount(
    NotificationGetUnreadCount event,
    Emitter<NotificationState> emit,
  ) async {
    final result = await _getUnreadCountUsecase(NoParams());
    result.fold(
      (failure) => emit(state.copyWith(
        status: NotificationStatus.error,
        errorMessage: failure.message,
      )),
      (_) {
        // Unread count retrieved, update state if needed
      },
    );
  }

  Future<void> _onNotificationMarkAsRead(
    NotificationMarkAsRead event,
    Emitter<NotificationState> emit,
  ) async {
    emit(state.copyWith(isMarkingAsRead: true));
    final result = await _markNotificationReadUsecase(event.notificationId);

    result.fold(
      (failure) => emit(
        state.copyWith(
          status: NotificationStatus.error,
          errorMessage: failure.message,
          isMarkingAsRead: false,
        ),
      ),
      (_) {
        // On success, update the notification in the list
        final updatedNotifs = state.notifs.map((notif) {
          return notif.id == event.notificationId
              ? notif.copyWith(isRead: true)
              : notif;
        }).toList();
        emit(state.copyWith(
          notifs: updatedNotifs,
          isMarkingAsRead: false,
        ));
      },
    );
  }

  Future<void> _onNotificationDeleted(
    NotificationDeleted event,
    Emitter<NotificationState> emit,
  ) async {
    final result = await _deleteNotificationUsecase(event.notificationId);

    result.fold(
      (failure) => emit(
        state.copyWith(
          status: NotificationStatus.error,
          errorMessage: failure.message,
        ),
      ),
      (_) {
        // On success, remove from list
        final updatedNotifs = state.notifs
            .where((p) => p.id != event.notificationId)
            .toList();
        emit(state.copyWith(notifs: updatedNotifs));
      },
    );
  }
}

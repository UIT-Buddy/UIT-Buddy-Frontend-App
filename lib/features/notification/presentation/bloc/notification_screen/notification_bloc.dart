import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uit_buddy_mobile/core/usecase/usecase_interface.dart';
import 'package:uit_buddy_mobile/features/notification/domain/usecases/notification_usecase.dart';
import 'package:uit_buddy_mobile/features/notification/presentation/bloc/notification_screen/notification_event.dart';
import 'package:uit_buddy_mobile/features/notification/presentation/bloc/notification_screen/notification_state.dart';

class NotificationBloc extends Bloc<NotificationEvent, NotificationState> {
  NotificationBloc({required GetNotificationUsecase getNotificationUsecase})
      : _getNotificationUsecase = getNotificationUsecase,
        super(const NotificationState()) {
    on<NotificationStarted>(_onNotificationStarted);
  }

  final GetNotificationUsecase _getNotificationUsecase;

  Future<void> _onNotificationStarted(
    NotificationStarted event,
    Emitter<NotificationState> emit,
  ) async {
    emit(state.copyWith(status: NotificationStatus.loading));

    final result = await _getNotificationUsecase(const NoParams());

    result.fold(
      (failure) => emit(
        state.copyWith(
          status: NotificationStatus.error,
          errorMessage: failure.message,
        ),
      ),
      (notificationEntity) => emit(
        state.copyWith(
          status: NotificationStatus.loaded,
          notificationEntity: notificationEntity,
        ),
      ),
    );
  }
}

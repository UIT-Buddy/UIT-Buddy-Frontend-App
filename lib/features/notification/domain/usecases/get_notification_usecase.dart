import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';
import 'package:uit_buddy_mobile/core/common/paged_result.dart';
import 'package:uit_buddy_mobile/core/error/failures.dart';
import 'package:uit_buddy_mobile/core/usecase/usecase_interface.dart';
import 'package:uit_buddy_mobile/features/notification/domain/entities/notification_entity.dart';
import 'package:uit_buddy_mobile/features/notification/domain/repositories/notification_repository.dart';

class GetNotificationUsecase implements UseCase<PagedResult<NotificationEntity>, NotificationParams> {
  GetNotificationUsecase({
    required NotificationRepository notificationRepository,
  }) : _notificationRepository = notificationRepository;
  final NotificationRepository _notificationRepository;
  @override
  Future<Either<Failure, PagedResult<NotificationEntity>>> call(NotificationParams params) async =>
      _notificationRepository.getNotifications(
        cursor: params.cursor,
        limit: params.limit
      );
}

class NotificationParams extends Equatable {
  final String? cursor;
  final int limit;

  const NotificationParams({
    this.cursor,
    this.limit = 10
  });

  @override
  List<Object?> get props => [cursor, limit];
}
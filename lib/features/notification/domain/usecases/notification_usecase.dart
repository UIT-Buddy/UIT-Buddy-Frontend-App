import 'package:fpdart/fpdart.dart';
import 'package:uit_buddy_mobile/core/error/failures.dart';
import 'package:uit_buddy_mobile/core/usecase/usecase_interface.dart';
import 'package:uit_buddy_mobile/features/notification/domain/entities/notification_entity.dart';
import 'package:uit_buddy_mobile/features/notification/domain/repositories/notification_repository.dart';

class GetNotificationUsecase
    implements UseCase<NotificationEntity, NoParams> {
  GetNotificationUsecase({required NotificationRepository notificationRepository})
    : _notificationRepository = notificationRepository;
  final NotificationRepository _notificationRepository;
  @override
  Future<Either<Failure, NotificationEntity>> call(NoParams params) async =>
      _notificationRepository.getNotifications();
}
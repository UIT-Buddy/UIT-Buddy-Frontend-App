import 'package:fpdart/fpdart.dart';
import 'package:uit_buddy_mobile/core/error/failures.dart';
import 'package:uit_buddy_mobile/core/usecase/usecase_interface.dart';
import 'package:uit_buddy_mobile/features/notification/domain/repositories/notification_repository.dart';

class MarkNotificationReadUsecase implements UseCase<void, String> {
  MarkNotificationReadUsecase({
    required NotificationRepository notificationRepository,
  }) : _notificationRepository = notificationRepository;
  final NotificationRepository _notificationRepository;
  @override
  Future<Either<Failure, Unit>> call(String notificationId) async =>
      _notificationRepository.markNotificationAsRead(notificationId);
}
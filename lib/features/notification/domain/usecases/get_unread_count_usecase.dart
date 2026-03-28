import 'package:fpdart/fpdart.dart';
import 'package:uit_buddy_mobile/core/error/failures.dart';
import 'package:uit_buddy_mobile/core/usecase/usecase_interface.dart';
import 'package:uit_buddy_mobile/features/notification/domain/repositories/notification_repository.dart';

class GetUnreadCountUsecase implements UseCase<void, NoParams> {
  GetUnreadCountUsecase({
    required NotificationRepository notificationRepository,
  }) : _notificationRepository = notificationRepository;
  final NotificationRepository _notificationRepository;
  @override
  Future<Either<Failure, int>> call(NoParams params) async =>
      _notificationRepository.getUnreadCount();
}

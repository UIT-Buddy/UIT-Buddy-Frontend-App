import 'package:fpdart/fpdart.dart';
import 'package:uit_buddy_mobile/core/error/failures.dart';
import 'package:uit_buddy_mobile/features/notification/domain/entities/notification_entity.dart';

abstract interface class NotificationRepository {
  Future<Either<Failure, NotificationEntity>> getNotifications();
}
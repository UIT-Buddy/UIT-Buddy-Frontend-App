import 'package:fpdart/fpdart.dart';
import 'package:uit_buddy_mobile/core/error/failures.dart';
import 'package:uit_buddy_mobile/features/notification/data/datasources/notification_datasource_interface.dart';
import 'package:uit_buddy_mobile/features/notification/data/mapper/notification_mapper.dart';
import 'package:uit_buddy_mobile/features/notification/domain/entities/notification_entity.dart';
import 'package:uit_buddy_mobile/features/notification/domain/repositories/notification_repository.dart';

class NotificationRepositoryImpl implements NotificationRepository {
  NotificationRepositoryImpl({
    required NotificationDatasourceInterface notificationDatasourceInterface,
  }) : _notificationDatasourceInterface = notificationDatasourceInterface;

  final NotificationDatasourceInterface _notificationDatasourceInterface;

  @override
  Future<Either<Failure, NotificationEntity>> getNotifications() async {
    try {
      final apiResponse = await _notificationDatasourceInterface
          .getNotifications();

      if (apiResponse.data == null) {
        return Left(Failure(apiResponse.message));
      }

      return Right(apiResponse.data!.toEntity());
    } on Exception catch (e) {
      return Left(Failure.fromException(e));
    }
  }
}

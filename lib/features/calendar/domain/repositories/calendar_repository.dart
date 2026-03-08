import 'package:fpdart/fpdart.dart';
import 'package:uit_buddy_mobile/core/error/failures.dart';
import 'package:uit_buddy_mobile/features/calendar/domain/entities/calendar_deadline_entity.dart';

abstract interface class CalendarRepository {
  Future<Either<Failure, CalendarDeadlineEntity>> getDeadline({
    required int month,
    required int year,
  });

  Future<Either<Failure, Unit>> createDeadline({
    required String name,
    required String courseId,
    required DateTime deadline,
  });
}

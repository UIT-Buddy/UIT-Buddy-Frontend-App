import 'package:fpdart/fpdart.dart';
import 'package:uit_buddy_mobile/core/error/failures.dart';
import 'package:uit_buddy_mobile/features/calendar/data/datasources/calendar_datasource_interface.dart';
import 'package:uit_buddy_mobile/features/calendar/data/mapper/calendar_mapper.dart';
import 'package:uit_buddy_mobile/features/calendar/domain/entities/calendar_deadline_entity.dart';
import 'package:uit_buddy_mobile/features/calendar/domain/repositories/calendar_repository.dart';

class CalendarRepositoryImpl implements CalendarRepository {
  CalendarRepositoryImpl({
    required CalendarDatasourceInterface calendarDatasourceInterface,
  }) : _calendarDatasourceInterface = calendarDatasourceInterface;

  final CalendarDatasourceInterface _calendarDatasourceInterface;

  @override
  Future<Either<Failure, CalendarDeadlineEntity>> getDeadline({
    required int month,
    required int year,
  }) async {
    try {
      final apiResponse = await _calendarDatasourceInterface.getDeadline(
        month: month,
        year: year,
      );

      if (apiResponse.data == null) {
        return Left(Failure(apiResponse.message));
      }

      return Right(apiResponse.data!.toEntity());
    } on Exception catch (e) {
      return Left(Failure.fromException(e));
    }
  }
}

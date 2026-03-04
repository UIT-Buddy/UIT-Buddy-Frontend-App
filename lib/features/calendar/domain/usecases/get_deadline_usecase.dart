import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:uit_buddy_mobile/core/error/failures.dart';
import 'package:uit_buddy_mobile/core/usecase/usecase_interface.dart';
import 'package:uit_buddy_mobile/features/calendar/domain/entities/calendar_deadline_entity.dart';
import 'package:uit_buddy_mobile/features/calendar/domain/repositories/calendar_repository.dart';

class GetDeadlineUsecase
    implements UseCase<CalendarDeadlineEntity, GetDeadlineParams> {
  GetDeadlineUsecase({required CalendarRepository calendarRepository})
    : _calendarRepository = calendarRepository;
  final CalendarRepository _calendarRepository;
  @override
  Future<Either<Failure, CalendarDeadlineEntity>> call(
    GetDeadlineParams params,
  ) async =>
      _calendarRepository.getDeadline(month: params.month, year: params.year);
}

@immutable
class GetDeadlineParams extends Equatable {
  const GetDeadlineParams({required this.month, required this.year});
  final int month;
  final int year;
  @override
  List<Object?> get props => [month, year];
}

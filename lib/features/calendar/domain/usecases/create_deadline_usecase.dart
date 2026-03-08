import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:uit_buddy_mobile/core/error/failures.dart';
import 'package:uit_buddy_mobile/core/usecase/usecase_interface.dart';
import 'package:uit_buddy_mobile/features/calendar/domain/repositories/calendar_repository.dart';

class CreateDeadlineUsecase implements UseCase<Unit, CreateDeadlineParams> {
  CreateDeadlineUsecase({required CalendarRepository calendarRepository})
    : _calendarRepository = calendarRepository;

  final CalendarRepository _calendarRepository;

  @override
  Future<Either<Failure, Unit>> call(CreateDeadlineParams params) =>
      _calendarRepository.createDeadline(
        name: params.name,
        courseId: params.courseId,
        deadline: params.deadline,
      );
}

@immutable
class CreateDeadlineParams extends Equatable {
  const CreateDeadlineParams({
    required this.name,
    required this.courseId,
    required this.deadline,
  });

  final String name;
  final String courseId;
  final DateTime deadline;

  @override
  List<Object?> get props => [name, courseId, deadline];
}

import 'package:fpdart/fpdart.dart';
import 'package:uit_buddy_mobile/core/error/failures.dart';
import 'package:uit_buddy_mobile/core/usecase/usecase_interface.dart';
import 'package:uit_buddy_mobile/features/calendar/domain/repositories/calendar_repository.dart';

class GetStudyingClassCodesUsecase implements UseCase<List<String>, NoParams> {
  GetStudyingClassCodesUsecase({required CalendarRepository calendarRepository})
    : _calendarRepository = calendarRepository;

  final CalendarRepository _calendarRepository;

  @override
  Future<Either<Failure, List<String>>> call(NoParams params) =>
      _calendarRepository.getStudyingClassCodes();
}

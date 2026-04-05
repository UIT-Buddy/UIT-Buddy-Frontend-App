import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';
import 'package:uit_buddy_mobile/core/error/failures.dart';
import 'package:uit_buddy_mobile/core/usecase/usecase_interface.dart';
import 'package:uit_buddy_mobile/features/calendar/domain/entities/course_details_entity.dart';
import 'package:uit_buddy_mobile/features/calendar/domain/repositories/course_repository.dart';

class SyncAssignmentsUsecase
    implements UseCase<List<CourseDetailsEntity>, SyncAssignmentsParams> {
  SyncAssignmentsUsecase({required CourseRepository courseRepository})
    : _courseRepository = courseRepository;

  final CourseRepository _courseRepository;

  @override
  Future<Either<Failure, List<CourseDetailsEntity>>> call(
    SyncAssignmentsParams params,
  ) {
    return _courseRepository.syncAssignments(
      month: params.month,
      year: params.year,
    );
  }
}

class SyncAssignmentsParams extends Equatable {
  const SyncAssignmentsParams({this.month, this.year});

  final int? month;
  final int? year;

  @override
  List<Object?> get props => [month, year];
}

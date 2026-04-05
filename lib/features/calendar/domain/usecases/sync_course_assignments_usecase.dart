import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';
import 'package:uit_buddy_mobile/core/error/failures.dart';
import 'package:uit_buddy_mobile/core/usecase/usecase_interface.dart';
import 'package:uit_buddy_mobile/features/calendar/domain/entities/course_content_entity.dart';
import 'package:uit_buddy_mobile/features/calendar/domain/repositories/course_repository.dart';

class SyncCourseAssignmentsUsecase
    implements UseCase<CourseContentEntity, SyncCourseAssignmentsParams> {
  SyncCourseAssignmentsUsecase({required CourseRepository courseRepository})
    : _courseRepository = courseRepository;

  final CourseRepository _courseRepository;

  @override
  Future<Either<Failure, CourseContentEntity>> call(
    SyncCourseAssignmentsParams params,
  ) {
    return _courseRepository.syncCourseAssignments(
      classId: params.classId,
      month: params.month,
      year: params.year,
    );
  }
}

class SyncCourseAssignmentsParams extends Equatable {
  const SyncCourseAssignmentsParams({
    required this.classId,
    this.month,
    this.year,
  });

  final String classId;
  final int? month;
  final int? year;

  @override
  List<Object?> get props => [classId, month, year];
}

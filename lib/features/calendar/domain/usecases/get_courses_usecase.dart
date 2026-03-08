import 'package:fpdart/fpdart.dart';
import 'package:uit_buddy_mobile/core/error/failures.dart';
import 'package:uit_buddy_mobile/core/usecase/usecase_interface.dart';
import 'package:uit_buddy_mobile/features/calendar/domain/entities/course_entity.dart';
import 'package:uit_buddy_mobile/features/calendar/domain/repositories/course_repository.dart';

class GetCoursesUsecase implements UseCase<List<CourseEntity>, NoParams> {
  GetCoursesUsecase({required CourseRepository courseRepository})
    : _courseRepository = courseRepository;

  final CourseRepository _courseRepository;

  @override
  Future<Either<Failure, List<CourseEntity>>> call(NoParams params) =>
      _courseRepository.getCourses();
}

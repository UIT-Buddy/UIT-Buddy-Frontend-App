import 'package:fpdart/fpdart.dart';
import 'package:uit_buddy_mobile/core/error/failures.dart';
import 'package:uit_buddy_mobile/features/calendar/domain/entities/course_entity.dart';

abstract interface class CourseRepository {
  Future<Either<Failure, List<CourseEntity>>> getCourses();
}

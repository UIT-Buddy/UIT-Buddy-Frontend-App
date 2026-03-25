import 'package:fpdart/fpdart.dart';
import 'package:uit_buddy_mobile/core/error/failures.dart';
import 'package:uit_buddy_mobile/features/calendar/domain/entities/course_details_entity.dart';
import 'package:uit_buddy_mobile/features/calendar/domain/entities/course_entity.dart';

abstract interface class CourseRepository {
  Future<Either<Failure, List<CourseEntity>>> getCourses();

  Future<Either<Failure, List<CourseDetailsEntity>>> getCoursesByMode({
    required int semester,
    required int year,
  });

  Future<Either<Failure, Unit>> uploadSchedule({
    required String filePath,
    required String fileName,
  });
}

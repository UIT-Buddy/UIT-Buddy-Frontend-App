import 'package:fpdart/fpdart.dart';
import 'package:uit_buddy_mobile/core/error/failures.dart';
import 'package:uit_buddy_mobile/features/calendar/domain/entities/course_content_entity.dart';
import 'package:uit_buddy_mobile/features/calendar/domain/entities/course_details_entity.dart';
import 'package:uit_buddy_mobile/features/calendar/domain/entities/course_entity.dart';

abstract interface class CourseRepository {
  Future<Either<Failure, List<CourseEntity>>> getCourses();

  Future<Either<Failure, List<CourseDetailsEntity>>> getCoursesByMode({
    required int semester,
    required int year,
  });

  Future<Either<Failure, List<CourseDetailsEntity>>> uploadSchedule({
    required String filePath,
    required String fileName,
  });

  /// Fetches assignment deadlines from Moodle for all enrolled courses.
  /// Should be called after [uploadSchedule].
  Future<Either<Failure, List<CourseDetailsEntity>>> syncAssignments({
    int? month,
    int? year,
  });

  /// Fetches assignment deadlines for a single course (by classId).
  /// Use for lazy-loading when the user opens a course's deadline view.
  Future<Either<Failure, CourseContentEntity>> syncCourseAssignments({
    required String classId,
    int? month,
    int? year,
  });
}

import 'package:uit_buddy_mobile/features/calendar/data/models/course_content_model.dart';
import 'package:uit_buddy_mobile/features/calendar/data/models/course_details_model.dart';
import 'package:uit_buddy_mobile/features/calendar/data/models/course_model.dart';

abstract interface class CourseDatasourceInterface {
  /// Returns all enrolled courses available for selection (for deadline modal).
  Future<List<CourseModel>> getCourses();

  /// Returns full course schedule details for the given [semester] and [year].
  Future<List<CourseDetailsModel>> getCoursesByMode({
    required int semester,
    required int year,
  });

  /// Uploads an ICS schedule file to the server and returns the parsed courses.
  Future<List<CourseDetailsModel>> uploadSchedule({
    required String filePath,
    required String fileName,
  });

  /// Syncs assignment deadlines from Moodle for all enrolled courses.
  /// Returns courses enriched with deadline statuses.
  Future<List<CourseDetailsModel>> syncAssignments({int? month, int? year});

  /// Syncs assignment deadlines for a single course (identified by classId).
  /// Used for lazy-loading deadlines when the user opens a course's deadline view.
  Future<CourseContentModel> syncCourseAssignments({
    required String classId,
    int? month,
    int? year,
  });
}

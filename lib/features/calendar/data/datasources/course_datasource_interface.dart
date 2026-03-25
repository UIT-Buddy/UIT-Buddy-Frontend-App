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

  /// Uploads an ICS schedule file to the server.
  Future<void> uploadSchedule({
    required String filePath,
    required String fileName,
  });
}

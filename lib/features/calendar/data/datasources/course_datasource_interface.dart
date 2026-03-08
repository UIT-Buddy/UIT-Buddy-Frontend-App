import 'package:uit_buddy_mobile/features/calendar/data/models/course_model.dart';

abstract interface class CourseDatasourceInterface {
  /// Returns all enrolled courses available for selection.
  Future<List<CourseModel>> getCourses();
}

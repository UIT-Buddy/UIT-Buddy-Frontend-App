import 'package:uit_buddy_mobile/features/calendar/data/models/course_model.dart';
import 'package:uit_buddy_mobile/features/calendar/domain/entities/course_entity.dart';

extension CourseMapper on CourseModel {
  CourseEntity toEntity() =>
      CourseEntity(courseId: courseId, courseName: courseName);
}

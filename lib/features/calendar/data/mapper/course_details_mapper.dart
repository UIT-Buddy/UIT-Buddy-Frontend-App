import 'package:uit_buddy_mobile/features/calendar/data/models/course_details_model.dart';
import 'package:uit_buddy_mobile/features/calendar/domain/entities/course_details_entity.dart';

extension CourseDetailsMapper on CourseDetailsModel {
  CourseDetailsEntity toEntity() => CourseDetailsEntity(
    courseId: courseId,
    classId: classId,
    labOfClassId: labOfClassId,
    isBlendedLearning: isBlendedLearning,
    courseName: courseName,
    startPeriod: startPeriod,
    endPeriod: endPeriod,
    startTime: startTime,
    endTime: endTime,
    startDate: DateTime.parse(startDate),
    endDate: DateTime.parse(endDate),
    credits: credits,
    dayOfWeek: dayOfWeek,
    lecturer: lecturer,
    room: room,
    deadlines: deadlines.map((d) => d.toEntity()).toList(),
  );
}

extension DeadlineDetailInCourseMapper on DeadlineDetailInCourseModel {
  DeadlineDetailEntity toEntity() => DeadlineDetailEntity(
    id: id,
    title: title,
    status: _mapStatus(status),
    deadline: DateTime.parse(deadline),
  );

  TaskEntityStatus _mapStatus(String s) => switch (s) {
    'done' => TaskEntityStatus.done,
    'nearDeadline' => TaskEntityStatus.nearDeadline,
    'overdue' => TaskEntityStatus.overdue,
    _ => TaskEntityStatus.upcoming,
  };
}

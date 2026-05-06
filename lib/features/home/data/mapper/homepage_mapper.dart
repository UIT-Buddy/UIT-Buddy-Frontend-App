import 'package:uit_buddy_mobile/features/home/data/models/homepage_model.dart';
import 'package:uit_buddy_mobile/features/home/data/models/homepage_paging_model.dart';
import 'package:uit_buddy_mobile/features/home/data/models/incoming_course_model.dart';
import 'package:uit_buddy_mobile/features/home/data/models/incoming_deadline_model.dart';
import 'package:uit_buddy_mobile/features/home/domain/entities/homepage_entity.dart';
import 'package:uit_buddy_mobile/features/home/domain/entities/homepage_paging_entity.dart';
import 'package:uit_buddy_mobile/features/home/domain/entities/incoming_course_entity.dart';
import 'package:uit_buddy_mobile/features/home/domain/entities/incoming_deadline_entity.dart';

extension HomePageModelToEntity on HomePageModel {
  HomePageEntity toEntity() {
    return HomePageEntity(
      studentName: studentName,
      todayClass: todayClass,
      unreadNotificationCount: unreadNotificationCount,
      incomingCourse: incomingCourse?.toEntity(),
      totalDeadlineCount: totalDeadlineCount,
      incomingDeadlines: incomingDeadlines
          .map((model) => model.toEntity())
          .toList(),
      paging: paging.toEntity(),
    );
  }
}

extension HomepagePagingModelToEntity on HomepagePagingModel {
  HomepagePagingEntity toEntity() {
    return HomepagePagingEntity(
      currentPage: currentPage,
      totalPages: totalPages,
      totalElements: totalElements,
    );
  }
}

extension IncomingCourseModelToEntity on IncomingCourseModel {
  IncomingCourseEntity toEntity() {
    return IncomingCourseEntity(
      remainingTime: remainingTime,
      studentsInClass: studentsInClass,
      courseCode: courseCode,
      courseName: courseName,
      roomCode: roomCode,
      lecturerName: lecturerName,
    );
  }
}

extension IncomingDeadlineModelToEntity on IncomingDeadlineModel {
  IncomingDeadlineEntity toEntity() {
    return IncomingDeadlineEntity(
      id: id,
      deadlineName: deadlineName,
      remainingTime: remainingTime.toEntity(),
      dueDate: dueDate,
    );
  }
}

extension RemainingTimeModelToEntity on RemainingTimeModel {
  RemainingTimeEntity toEntity() {
    TimeUnit mappedUnitName;
    switch (unitName.toUpperCase()) {
      case 'MINUTE':
        mappedUnitName = TimeUnit.minute;
        break;
      case 'HOUR':
        mappedUnitName = TimeUnit.hour;
        break;
      case 'DAY':
        mappedUnitName = TimeUnit.day;
        break;
      case 'WEEK':
        mappedUnitName = TimeUnit.week;
        break;
      default:
        mappedUnitName = TimeUnit.day;
    }

    return RemainingTimeEntity(unit: unit, unitName: mappedUnitName);
  }
}

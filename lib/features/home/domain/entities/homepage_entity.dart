import 'package:equatable/equatable.dart';
import 'package:uit_buddy_mobile/features/home/domain/entities/incoming_course_entity.dart';
import 'package:uit_buddy_mobile/features/home/domain/entities/incoming_deadline_entity.dart';
import 'package:uit_buddy_mobile/features/home/domain/entities/homepage_paging_entity.dart';

class HomePageEntity extends Equatable {
  const HomePageEntity({
    required this.studentName,
    required this.todayClass,
    required this.unreadNotificationCount,
    this.incomingCourse,
    required this.totalDeadlineCount,
    required this.incomingDeadlines,
    required this.paging,
  });

  final String studentName;
  final int todayClass;
  final int unreadNotificationCount;
  final IncomingCourseEntity? incomingCourse;
  final int totalDeadlineCount;
  final List<IncomingDeadlineEntity> incomingDeadlines;
  final HomepagePagingEntity paging;

  @override
  List<Object?> get props => [
    studentName,
    todayClass,
    unreadNotificationCount,
    incomingCourse,
    totalDeadlineCount,
    incomingDeadlines,
    paging,
  ];
}

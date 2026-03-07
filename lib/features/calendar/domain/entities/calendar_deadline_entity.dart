import 'package:equatable/equatable.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

@immutable
class CalendarDeadlineEntity extends Equatable {
  final int month;
  final int year;
  final List<CalendarDeadlineItemEntity> items;

  const CalendarDeadlineEntity({
    required this.month,
    required this.year,
    required this.items,
  });

  @override
  List<Object?> get props => [month, year, items];
}

enum CalendarDeadlineItemEntityStatus {
  done,
  upcoming,
  nearDeadline,
  overdue,
  empty,
}

@immutable
class CalendarDeadlineItemEntity extends Equatable {
  final int day;
  final bool isSelected;
  final CalendarDeadlineItemEntityStatus status;
  final List<DeadlineDetailEntity> details;

  const CalendarDeadlineItemEntity({
    required this.day,
    this.isSelected = false,
    required this.status,
    required this.details,
  });

  @override
  List<Object?> get props => [day, isSelected, status, details];
}

@immutable
class DeadlineDetailEntity extends Equatable {
  final String id;
  final String title;
  final CalendarDeadlineItemEntityStatus status;
  final String courseId;
  final DateTime deadline;

  const DeadlineDetailEntity({
    required this.id,
    required this.title,
    required this.status,
    required this.courseId,
    required this.deadline,
  });

  @override
  List<Object?> get props => [id, title, status, courseId, deadline];
}

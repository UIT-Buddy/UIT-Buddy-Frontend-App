import 'package:equatable/equatable.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

@immutable
class CalendarDeadlineModel extends Equatable {
  final int month;
  final int year;
  final List<CalendarDeadlineItemModel> items;

  const CalendarDeadlineModel({
    required this.month,
    required this.year,
    required this.items,
  });

  @override
  List<Object?> get props => [month, year, items];
}

@immutable
class CalendarDeadlineItemModel extends Equatable {
  final int day;
  final String status;
  final List<DeadlineDetailModel> details;

  const CalendarDeadlineItemModel({
    required this.day,
    required this.status,
    required this.details,
  });

  @override
  List<Object?> get props => [day, status, details];
}

@immutable
class DeadlineDetailModel extends Equatable {
  final String id;
  final String title;
  final String status;
  final String courseId;
  final String deadline;

  const DeadlineDetailModel({
    required this.id,
    required this.title,
    required this.status,
    required this.courseId,
    required this.deadline,
  });

  @override
  List<Object?> get props => [id, title, status, courseId, deadline];
}

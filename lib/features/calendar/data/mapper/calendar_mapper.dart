import 'package:uit_buddy_mobile/features/calendar/data/models/calendar_deadline_model.dart'
    as model;
import 'package:uit_buddy_mobile/features/calendar/domain/entities/calendar_deadline_entity.dart'
    as entity;

extension DeadlineDetailMapper on model.DeadlineDetailModel {
  entity.DeadlineDetailEntity toEntity() => entity.DeadlineDetailEntity(
    id: id,
    title: title,
    status: _mapStatus(status),
    courseId: courseId,
    deadline: DateTime.parse(deadline),
  );

  entity.CalendarDeadlineItemEntityStatus _mapStatus(String status) {
    switch (status.toLowerCase()) {
      case 'done':
        return entity.CalendarDeadlineItemEntityStatus.done;
      case 'upcoming':
        return entity.CalendarDeadlineItemEntityStatus.upcoming;
      case 'neardeadline':
        return entity.CalendarDeadlineItemEntityStatus.nearDeadline;
      case 'overdue':
        return entity.CalendarDeadlineItemEntityStatus.overdue;
      case 'empty':
        return entity.CalendarDeadlineItemEntityStatus.empty;
      default:
        return entity.CalendarDeadlineItemEntityStatus.empty;
    }
  }
}

extension CalendarDeadlineItemMapper on model.CalendarDeadlineItemModel {
  entity.CalendarDeadlineItemEntity toEntity() =>
      entity.CalendarDeadlineItemEntity(
        day: day,
        isSelected: false,
        status: _mapStatus(status),
        details: details.map((e) => e.toEntity()).toList(),
      );

  entity.CalendarDeadlineItemEntityStatus _mapStatus(String status) {
    switch (status.toLowerCase()) {
      case 'done':
        return entity.CalendarDeadlineItemEntityStatus.done;
      case 'upcoming':
        return entity.CalendarDeadlineItemEntityStatus.upcoming;
      case 'neardeadline':
        return entity.CalendarDeadlineItemEntityStatus.nearDeadline;
      case 'overdue':
        return entity.CalendarDeadlineItemEntityStatus.overdue;
      case 'empty':
        return entity.CalendarDeadlineItemEntityStatus.empty;
      default:
        return entity.CalendarDeadlineItemEntityStatus.empty;
    }
  }
}

extension CalendarDeadlineMapper on model.CalendarDeadlineModel {
  entity.CalendarDeadlineEntity toEntity() => entity.CalendarDeadlineEntity(
    month: month,
    year: year,
    items: items.map((e) => e.toEntity()).toList(),
  );
}

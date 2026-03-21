import 'package:uit_buddy_mobile/features/profile/data/models/task_model.dart'
    as model;
import 'package:uit_buddy_mobile/features/profile/domain/entities/task_detail_entity.dart'
    as entity;
import 'package:uit_buddy_mobile/features/profile/domain/entities/task_entity.dart'
    as entity;

extension TaskModelMapper on model.TaskModel {
  entity.TaskEntity toEntity() => entity.TaskEntity(
    id: id,
    classCode: classCode,
    taskDetail: taskDetail.toEntity(),
  );
}

extension TaskDetailModelMapper on model.TaskDetailModel {
  entity.TaskDetailEntity toEntity() => entity.TaskDetailEntity(
    name: name,
    title: title,
    description: description,
    url: url,
    priority: _mapPriority(priority),
    openDate: openDate,
    dueDate: dueDate,
    reminderTime: reminderTime,
    status: _mapStatus(status),
  );

  entity.TaskPriority _mapPriority(String value) {
    switch (value) {
      case 'high':
        return entity.TaskPriority.high;
      case 'medium':
        return entity.TaskPriority.medium;
      default:
        return entity.TaskPriority.low;
    }
  }

  entity.TaskStatus _mapStatus(String value) {
    switch (value) {
      case 'completed':
        return entity.TaskStatus.completed;
      case 'overdue':
        return entity.TaskStatus.overdue;
      default:
        return entity.TaskStatus.pending;
    }
  }
}

extension TaskEntityMapper on entity.TaskEntity {
  model.TaskModel toModel() => model.TaskModel(
    id: id,
    classCode: classCode,
    taskDetail: taskDetail.toModel(),
  );
}

extension TaskDetailEntityMapper on entity.TaskDetailEntity {
  model.TaskDetailModel toModel() => model.TaskDetailModel(
    name: name,
    title: title,
    description: description,
    url: url,
    priority: priority.name,
    openDate: openDate,
    dueDate: dueDate,
    reminderTime: reminderTime,
    status: status.name,
  );
}

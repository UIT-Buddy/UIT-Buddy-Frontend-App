import 'package:equatable/equatable.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

@immutable
class TaskModel extends Equatable {
  final String id;
  final String classCode;
  final TaskDetailModel taskDetail;

  const TaskModel({
    required this.id,
    required this.classCode,
    required this.taskDetail,
  });

  TaskModel copyWith({String? id, String? classCode, TaskDetailModel? taskDetail}) {
    return TaskModel(
      id: id ?? this.id,
      classCode: classCode ?? this.classCode,
      taskDetail: taskDetail ?? this.taskDetail,
    );
  }

  @override
  List<Object?> get props => [id, classCode, taskDetail];
}

@immutable
class TaskDetailModel extends Equatable {
  final String name;
  final String title;
  final String description;
  final String url;
  final String priority; // 'low' | 'medium' | 'high'
  final DateTime openDate;
  final DateTime dueDate;
  final DateTime reminderTime;
  final String status; // 'pending' | 'completed' | 'overdue'

  const TaskDetailModel({
    required this.name,
    required this.title,
    required this.description,
    required this.url,
    required this.priority,
    required this.openDate,
    required this.dueDate,
    required this.reminderTime,
    required this.status,
  });

  TaskDetailModel copyWith({String? status}) {
    return TaskDetailModel(
      name: name,
      title: title,
      description: description,
      url: url,
      priority: priority,
      openDate: openDate,
      dueDate: dueDate,
      reminderTime: reminderTime,
      status: status ?? this.status,
    );
  }

  @override
  List<Object?> get props => [
    name, title, description, url, priority, openDate, dueDate, reminderTime, status,
  ];
}

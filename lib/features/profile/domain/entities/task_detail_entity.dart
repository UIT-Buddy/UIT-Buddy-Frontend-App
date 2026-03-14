import 'package:equatable/equatable.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

enum TaskPriority { low, medium, high }

enum TaskStatus { pending, completed, overdue }

@immutable
class TaskDetailEntity extends Equatable {
  final String name;
  final String title;
  final String description;
  final String url;
  final TaskPriority priority;
  final DateTime openDate;
  final DateTime dueDate;
  final DateTime reminderTime;
  final TaskStatus status;

  const TaskDetailEntity({
    required this.name,
    required this.title,
    required this.dueDate,
    required this.description,
    required this.url,
    required this.priority,
    required this.openDate,
    required this.reminderTime,
    required this.status,
  });

  TaskDetailEntity copyWith({
    String? name,
    String? title,
    DateTime? dueDate,
    String? description,
    String? url,
    TaskPriority? priority,
    DateTime? openDate,
    DateTime? reminderTime,
    TaskStatus? status,
  }) {
    return TaskDetailEntity(
      name: name ?? this.name,
      title: title ?? this.title,
      dueDate: dueDate ?? this.dueDate,
      description: description ?? this.description,
      url: url ?? this.url,
      priority: priority ?? this.priority,
      openDate: openDate ?? this.openDate,
      reminderTime: reminderTime ?? this.reminderTime,
      status: status ?? this.status,
    );
  }

  @override
  List<Object?> get props => [name, title, dueDate, description, url, priority, openDate, reminderTime, status];
}
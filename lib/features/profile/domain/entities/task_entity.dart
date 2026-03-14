import 'package:equatable/equatable.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:uit_buddy_mobile/features/profile/domain/entities/task_detail_entity.dart';

@immutable
class TaskEntity extends Equatable {
  final String id;
  final String classCode;
  final TaskDetailEntity taskDetail;

  const TaskEntity({
    required this.id,
    required this.classCode,
    required this.taskDetail,
  });

  TaskEntity copyWith({
    String? id,
    String? classCode,
    TaskDetailEntity? taskDetail,
  }) {
    return TaskEntity(
      id: id ?? this.id,
      classCode: classCode ?? this.classCode,
      taskDetail: taskDetail ?? this.taskDetail,
    );
  }

  @override
  List<Object?> get props => [id, classCode, taskDetail];
}
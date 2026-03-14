import 'package:uit_buddy_mobile/features/profile/data/models/task_model.dart';

abstract interface class TaskDatasourceInterface {
  Future<List<TaskModel>> getTasks();
  Future<TaskModel> createTask({required TaskModel task});
  Future<TaskModel> updateTask({required TaskModel task});
  Future<void> deleteTask({required String taskId});
  Future<void> markTaskCompleted({required String taskId});
}

import 'package:uit_buddy_mobile/features/deadline/data/models/deadline_model.dart';

abstract interface class DeadlineDatasource {
  Future<DeadlineDataModel> getDeadlines();
  Future<void> createDeadline({
    required String classCode,
    required DateTime dueDate,
    required String exerciseName,
  });
  Future<void> updateDeadline({
    required String studentTaskId,
    required DateTime dueDate,
    required String exerciseName,
    required String status,
  });
  Future<DeadlineModel> getDeadlineDetail(String deadlineId);
}

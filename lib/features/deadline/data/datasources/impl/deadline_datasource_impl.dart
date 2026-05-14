import 'package:dio/dio.dart';
import 'package:uit_buddy_mobile/features/deadline/data/datasources/deadline_datasource.dart';
import 'package:uit_buddy_mobile/features/deadline/data/models/deadline_model.dart';

class DeadlineDatasourceImpl implements DeadlineDatasource {
  DeadlineDatasourceImpl({required Dio dio}) : _dio = dio;

  final Dio _dio;

  @override
  Future<DeadlineDataModel> getDeadlines() async {
    final response = await _dio.get<Map<String, dynamic>>(
      '/api/schedule/deadline',
    );
    return DeadlineDataModel.fromJson(
      response.data!['data'] as Map<String, dynamic>,
    );
  }

  @override
  Future<void> createDeadline({
    required String classCode,
    required DateTime dueDate,
    required String exerciseName,
  }) async {
    await _dio.post(
      '/api/schedule/deadline',
      data: {
        'classCode': classCode,
        'dueDate': dueDate.toIso8601String(),
        'exerciseName': exerciseName,
      },
    );
  }

  @override
  Future<void> updateDeadline({
    required String studentTaskId,
    required DateTime dueDate,
    required String exerciseName,
    required String status,
  }) async {
    await _dio.patch(
      '/api/schedule/deadline',
      data: {
        'studentTaskId': studentTaskId,
        'dueDate': dueDate.toIso8601String(),
        'exerciseName': exerciseName,
        'status': status,
      },
    );
  }

  @override
  Future<DeadlineModel> getDeadlineDetail(String deadlineId) async {
    final response = await _dio.get<Map<String, dynamic>>(
      '/api/schedule/deadline/$deadlineId',
    );
    return DeadlineModel.fromJson(
      response.data!['data'] as Map<String, dynamic>,
    );
  }
}

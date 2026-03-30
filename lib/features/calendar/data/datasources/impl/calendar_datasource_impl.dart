import 'package:dio/dio.dart';
import 'package:uit_buddy_mobile/core/network/api/api_response.dart';
import 'package:uit_buddy_mobile/features/calendar/data/datasources/calendar_datasource_interface.dart';
import 'package:uit_buddy_mobile/features/calendar/data/models/calendar_deadline_model.dart';

class CalendarDatasourceImpl implements CalendarDatasourceInterface {
  CalendarDatasourceImpl({required Dio dio}) : _dio = dio;

  final Dio _dio;

  @override
  Future<ApiResponse<CalendarDeadlineModel>> getDeadline({
    required int month,
    required int year,
  }) async {
    final response = await _dio.get<Map<String, dynamic>>(
      '/api/schedule/deadline',
      queryParameters: {'month': month, 'year': year},
    );
    final json = response.data!;
    final apiData = json['data'] as Map<String, dynamic>;
    final courseContents = apiData['courseContents'] as List<dynamic>;

    final Map<int, List<DeadlineDetailModel>> byDay = {};
    var idx = 0;

    for (final course in courseContents) {
      final courseName = course['courseName'] as String;
      final exercises = course['exercises'] as List<dynamic>;
      for (final exercise in exercises) {
        final dueDateStr = exercise['dueDate'] as String;
        final dueDate = DateTime.parse(dueDateStr);
        if (dueDate.month != month || dueDate.year != year) {
          idx++;
          continue;
        }
        final day = dueDate.day;
        byDay.putIfAbsent(day, () => []);
        byDay[day]!.add(
          DeadlineDetailModel(
            id: '$idx',
            title: exercise['exerciseName'] as String,
            status: (exercise['status'] as String).toLowerCase(),
            courseId: courseName,
            deadline: dueDateStr,
          ),
        );
        idx++;
      }
    }

    final items = byDay.entries.map((entry) {
      return CalendarDeadlineItemModel(
        day: entry.key,
        status: _dominantStatus(entry.value.map((d) => d.status).toList()),
        details: entry.value,
      );
    }).toList()..sort((a, b) => a.day.compareTo(b.day));

    return ApiResponse<CalendarDeadlineModel>(
      statusCode: json['statusCode'] as int,
      message: json['message'] as String,
      data: CalendarDeadlineModel(month: month, year: year, items: items),
    );
  }

  String _dominantStatus(List<String> statuses) {
    if (statuses.contains('overdue')) return 'overdue';
    if (statuses.contains('upcoming')) return 'upcoming';
    if (statuses.contains('neardeadline')) return 'neardeadline';
    if (statuses.contains('done')) return 'done';
    return 'empty';
  }

  @override
  Future<ApiResponse<List<String>>> getStudyingClassCodes() async {
    final response = await _dio.get<Map<String, dynamic>>(
      '/api/schedule/deadline/class-codes/studying',
    );
    final json = response.data!;
    final dataList = json['data'] as List<dynamic>;
    final classCodes = dataList.map((e) => e as String).toList();
    return ApiResponse<List<String>>(
      statusCode: json['statusCode'] as int,
      message: json['message'] as String,
      data: classCodes,
    );
  }

  @override
  Future<void> createDeadline({
    required String name,
    String? classCode,
    required DateTime deadline,
  }) async {
    final Map<String, dynamic> data = {
      'exerciseName': name,
      'dueDate': deadline.toIso8601String(),
    };
    if (classCode != null && classCode.isNotEmpty) {
      data['classCode'] = classCode;
    }
    await _dio.post<void>('/api/schedule/deadline', data: data);
  }
}

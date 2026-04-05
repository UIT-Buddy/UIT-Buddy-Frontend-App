import 'package:dio/dio.dart';
import 'package:uit_buddy_mobile/core/network/api/api_response.dart';
import 'package:uit_buddy_mobile/features/calendar/data/datasources/course_datasource_interface.dart';
import 'package:uit_buddy_mobile/features/calendar/data/models/course_content_model.dart';
import 'package:uit_buddy_mobile/features/calendar/data/models/course_details_model.dart';
import 'package:uit_buddy_mobile/features/calendar/data/models/course_model.dart';

class CourseDatasourceImpl implements CourseDatasourceInterface {
  CourseDatasourceImpl({required Dio dio}) : _dio = dio;

  final Dio _dio;

  @override
  Future<List<CourseModel>> getCourses() async {
    await Future.delayed(const Duration(milliseconds: 100));
    // TODO: replace with real API call when endpoint is ready
    return const [];
  }

  @override
  Future<List<CourseDetailsModel>> getCoursesByMode({
    required int semester,
    required int year,
  }) async {
    final response = await _dio.get<Map<String, dynamic>>(
      '/api/schedule/calendar',
      queryParameters: {'semester': semester, 'year': year},
    );
    final body = response.data!;
    // The `/api/schedule/calendar` endpoint wraps courses in an object
    // (data: { ... }) rather than a plain list (data: [...]).
    // _extractCourseList handles both shapes.
    final courseList = _extractCourseList(body['data']);
    return courseList
        .map((e) => CourseDetailsModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  /// Handles two possible API shapes for the `data` field:
  /// - `data: [...]`              → a direct list of courses
  /// - `data: { courses: [...] }` → a wrapper object; picks the first List value
  List<dynamic> _extractCourseList(dynamic data) {
    if (data == null) return const [];
    if (data is List) return data;
    if (data is Map<String, dynamic>) {
      // Try common key names first, then fall back to the first list value
      for (final key in ['courses', 'data', 'items', 'schedule']) {
        if (data[key] is List) return data[key] as List;
      }
      final firstList = data.values.whereType<List>().firstOrNull;
      return firstList ?? const [];
    }
    return const [];
  }

  @override
  Future<List<CourseDetailsModel>> uploadSchedule({
    required String filePath,
    required String fileName,
  }) async {
    final formData = FormData.fromMap({
      'icsFile': await MultipartFile.fromFile(filePath, filename: fileName),
    });
    final response = await _dio.post<Map<String, dynamic>>(
      '/api/schedule/upload',
      data: formData,
    );
    final apiResponse = apiResponseListFromJson<CourseDetailsModel>(
      response.data!,
      CourseDetailsModel.fromJson,
    );
    return apiResponse.data ?? const [];
  }

  @override
  Future<List<CourseDetailsModel>> syncAssignments({
    int? month,
    int? year,
  }) async {
    final queryParams = <String, dynamic>{};
    if (month != null) queryParams['month'] = month;
    if (year != null) queryParams['year'] = year;

    final response = await _dio.post<Map<String, dynamic>>(
      '/api/schedule/assignments/sync',
      queryParameters: queryParams.isEmpty ? null : queryParams,
    );
    final apiResponse = apiResponseListFromJson<CourseDetailsModel>(
      response.data!,
      CourseDetailsModel.fromJson,
    );
    return apiResponse.data ?? const [];
  }

  @override
  Future<CourseContentModel> syncCourseAssignments({
    required String classId,
    int? month,
    int? year,
  }) async {
    final queryParams = <String, dynamic>{};
    if (month != null) queryParams['month'] = month;
    if (year != null) queryParams['year'] = year;

    final response = await _dio.post<Map<String, dynamic>>(
      '/api/schedule/assignments/sync/$classId',
      queryParameters: queryParams.isEmpty ? null : queryParams,
    );
    final apiResponse = apiResponseObjectFromJson<CourseContentModel>(
      response.data!,
      CourseContentModel.fromJson,
    );
    return apiResponse.data!;
  }
}

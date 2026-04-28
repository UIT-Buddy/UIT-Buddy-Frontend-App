import 'package:dio/dio.dart';
import 'package:uit_buddy_mobile/core/network/api/api_response.dart';
import 'package:uit_buddy_mobile/features/profile/data/datasources/academic_detail_datasource_interface.dart';
import 'package:uit_buddy_mobile/features/profile/data/models/academic_detail_model.dart';
import 'package:uit_buddy_mobile/features/profile/data/models/semester_detail_model.dart';

class AcademicDetailDatasourceImpl
    implements AcademicDetailDatasourceInterface {
  AcademicDetailDatasourceImpl({required Dio dio}) : _dio = dio;

  final Dio _dio;

  @override
  Future<String> importGradeData({
    required String filePath,
    required String fileName,
  }) async {
    final formData = FormData.fromMap({
      'gradeFile': await MultipartFile.fromFile(filePath, filename: fileName),
      'pdfFile': true,
    });
    final response = await _dio.post<Map<String, dynamic>>(
      '/api/grade/import',
      data: formData,
    );
    return response.data!['data'] as String;
  }

  @override
  Future<AcademicDetailModel> getAcademicSummary() async {
    final res = await _dio.get<Map<String, dynamic>>('/api/grade/summary');
    final apiRes = apiResponseObjectFromJson<AcademicDetailModel>(
      res.data!,
      AcademicDetailModel.fromJson,
    );
    return apiRes.data!;
  }

  @override
  Future<SemesterDetailModel> getGradesBySemester(String semester) async {
    //TODO
    return SemesterDetailModel(
      id: "0",
      accumulatedCredits: 0,
      averageGradeScale10: 0,
      averageGradeScale4: 0,
      grades: [],
      totalCredits: 0,
      totalCreditsByCategory: [],
    );
  }

  @override
  Future<List<SemesterDetailModel>> getAllGrades() async {
    //TODO
    return [];
  }
}

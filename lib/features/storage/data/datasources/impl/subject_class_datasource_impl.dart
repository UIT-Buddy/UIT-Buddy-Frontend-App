import 'package:uit_buddy_mobile/core/network/api/api_response.dart';
import 'package:uit_buddy_mobile/features/storage/data/datasources/subject_class_datasource_interface.dart';
import 'package:uit_buddy_mobile/features/storage/data/models/subject_class_model.dart';
import 'package:uit_buddy_mobile/features/storage/domain/entities/course_entity.dart';

class SubjectClassDatasourceImpl implements SubjectClassDatasourceInterface {
  @override
  Future<ApiResponse<List<SubjectClassModel>>> getClasses() async {
    try {
      await Future.delayed(const Duration(milliseconds: 500));

      return ApiResponse<List<SubjectClassModel>>(
        data: [
          SubjectClassModel(
            classCode: 'SE347.Q11',
            courseCode: 'SE347',
            course: const CourseEntity(
              courseCode: 'SE347',
              courseName: 'Công nghệ Web và ứng dụng',
            ),
          ),
          SubjectClassModel(
            classCode: 'SE346.Q21',
            courseCode: 'SE346',
            course: const CourseEntity(
              courseCode: 'SE346',
              courseName: 'Kỹ thuật phần mềm',
            ),
          ),
          SubjectClassModel(
            classCode: 'CS427.Q11',
            courseCode: 'CS427',
            course: const CourseEntity(
              courseCode: 'CS427',
              courseName: 'Lập trình di động',
            ),
          ),
        ],
        message: 'Classes fetched successfully.',
        statusCode: 200,
      );
    } catch (e) {
      return ApiResponse<List<SubjectClassModel>>(
        data: null,
        message: 'Failed to fetch classes.',
        statusCode: 500,
      );
    }
  }
}

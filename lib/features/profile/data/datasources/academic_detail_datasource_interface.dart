import 'package:uit_buddy_mobile/features/profile/data/models/academic_detail_model.dart';
import 'package:uit_buddy_mobile/features/profile/data/models/semester_detail_model.dart';

abstract interface class AcademicDetailDatasourceInterface {
  Future<AcademicDetailModel> getAcademicSummary();

  Future<String> importGradeData({
    required String filePath,
    required String fileName,
  });
  Future<SemesterDetailModel> getGradesBySemester(String semester);
  Future<List<SemesterDetailModel>> getAllGrades();
}

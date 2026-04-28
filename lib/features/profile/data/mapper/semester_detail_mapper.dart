import 'package:uit_buddy_mobile/features/profile/data/models/grade_model.dart';
import 'package:uit_buddy_mobile/features/profile/data/models/semester_detail_model.dart';
import 'package:uit_buddy_mobile/features/profile/domain/entities/semester_detail_entity.dart';

extension SemesterDetailMapper on SemesterDetailModel {
  SemesterDetailEntity toEntity() => SemesterDetailEntity(
    id: id,
    accumulatedCredits: accumulatedCredits,
    averageGradeScale10: averageGradeScale10,
    averageGradeScale4: averageGradeScale4,
    grades: grades.map((e) => e.toEntity()).toList(),
    totalCredits: totalCredits,
    totalCreditsByCategory: totalCreditsByCategory,
  );
}

extension GradeMapper on GradeModel {
  GradeEntity toEntity() => GradeEntity(
    id: id,
    courseCode: courseCode,
    courseName: courseName,
    courseType: courseType,
    finalGrade: finalGrade,
    labGrade: labGrade,
    midtermGrade: midtermGrade,
    processGrade: processGrade,
    totalGrade: totalGrade,
    credits: credits,
  );
}

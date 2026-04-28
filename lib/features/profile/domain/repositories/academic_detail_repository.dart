import 'package:fpdart/fpdart.dart';
import 'package:uit_buddy_mobile/core/error/failures.dart';
import 'package:uit_buddy_mobile/features/profile/domain/entities/academic_detail_entity.dart';
import 'package:uit_buddy_mobile/features/profile/domain/entities/semester_detail_entity.dart';

abstract interface class AcademicDetailRepository {
  Future<Either<Failure, AcademicDetailEntity>> getAcademicSummary();
  Future<Either<Failure, String>> importGradeData({
    required String filePath,
    required String fileName,
  });
  Future<Either<Failure, SemesterDetailEntity>> getGradesBySemester(
    String semester,
  );
  Future<Either<Failure, List<SemesterDetailEntity>>> getAllGrades();
}

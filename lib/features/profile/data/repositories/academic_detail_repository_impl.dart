import 'package:fpdart/fpdart.dart';
import 'package:uit_buddy_mobile/core/error/failures.dart';
import 'package:uit_buddy_mobile/features/profile/data/datasources/academic_detail_datasource_interface.dart';
import 'package:uit_buddy_mobile/features/profile/data/mapper/academic_detail_mapper.dart';
import 'package:uit_buddy_mobile/features/profile/data/mapper/semester_detail_mapper.dart';
import 'package:uit_buddy_mobile/features/profile/domain/entities/academic_detail_entity.dart';
import 'package:uit_buddy_mobile/features/profile/domain/entities/semester_detail_entity.dart';
import 'package:uit_buddy_mobile/features/profile/domain/repositories/academic_detail_repository.dart';

class AcademicDetailRepositoryImpl implements AcademicDetailRepository {
  AcademicDetailRepositoryImpl({
    required AcademicDetailDatasourceInterface
    academicDetailDatasourceInterface,
  }) : _academicDetailDatasourceInterface = academicDetailDatasourceInterface;

  final AcademicDetailDatasourceInterface _academicDetailDatasourceInterface;

  @override
  Future<Either<Failure, AcademicDetailEntity>> getAcademicSummary() async {
    try {
      final res = await _academicDetailDatasourceInterface.getAcademicSummary();
      return Right(res.toEntity());
    } on Exception catch (e) {
      return Left(Failure.fromException(e));
    }
  }

  @override
  Future<Either<Failure, String>> importGradeData({
    required String filePath,
    required String fileName,
  }) async {
    try {
      final res = await _academicDetailDatasourceInterface.importGradeData(
        fileName: fileName,
        filePath: filePath,
      );
      return Right(res);
    } on Exception catch (e) {
      return Left(Failure.fromException(e));
    }
  }

  @override
  Future<Either<Failure, SemesterDetailEntity>> getGradesBySemester(
    String semester,
  ) async {
    try {
      final res = await _academicDetailDatasourceInterface.getGradesBySemester(
        semester,
      );
      return Right(res.toEntity());
    } on Exception catch (e) {
      return Left(Failure.fromException(e));
    }
  }

  @override
  Future<Either<Failure, List<SemesterDetailEntity>>> getAllGrades() async {
    try {
      final res = await _academicDetailDatasourceInterface.getAllGrades();
      return Right(res.map((e) => e.toEntity()).toList());
    } on Exception catch (e) {
      return Left(Failure.fromException(e));
    }
  }
}

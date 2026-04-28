import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';
import 'package:uit_buddy_mobile/core/error/failures.dart';
import 'package:uit_buddy_mobile/core/usecase/usecase_interface.dart';
import 'package:uit_buddy_mobile/features/profile/domain/repositories/academic_detail_repository.dart';

class ImportGradeUsecase implements UseCase<String, ImportGradeParams> {
  ImportGradeUsecase({
    required AcademicDetailRepository academicDetailRepository,
  }) : _academicDetailRepository = academicDetailRepository;

  final AcademicDetailRepository _academicDetailRepository;

  @override
  Future<Either<Failure, String>> call(ImportGradeParams params) {
    return _academicDetailRepository.importGradeData(
      fileName: params.fileName,
      filePath: params.filePath,
    );
  }
}

class ImportGradeParams extends Equatable {
  const ImportGradeParams({required this.filePath, required this.fileName});

  final String filePath;
  final String fileName;

  @override
  List<Object?> get props => [filePath, fileName];
}

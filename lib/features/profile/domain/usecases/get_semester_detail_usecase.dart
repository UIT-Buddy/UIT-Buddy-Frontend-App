import 'package:fpdart/fpdart.dart';
import 'package:uit_buddy_mobile/core/error/failures.dart';
import 'package:uit_buddy_mobile/core/usecase/usecase_interface.dart';
import 'package:uit_buddy_mobile/features/profile/domain/entities/semester_detail_entity.dart';
import 'package:uit_buddy_mobile/features/profile/domain/repositories/academic_detail_repository.dart';

class GetSemesterDetailsUsecase
    implements UseCase<List<SemesterDetailEntity>, NoParams> {
  GetSemesterDetailsUsecase({
    required AcademicDetailRepository academicDetailRepository,
  }) : _academicDetailRepository = academicDetailRepository;

  final AcademicDetailRepository _academicDetailRepository;

  @override
  Future<Either<Failure, List<SemesterDetailEntity>>> call(
    NoParams params,
  ) async => _academicDetailRepository.getAllGrades();
}

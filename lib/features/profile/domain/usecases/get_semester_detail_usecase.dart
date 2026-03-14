import 'package:fpdart/fpdart.dart';
import 'package:uit_buddy_mobile/core/error/failures.dart';
import 'package:uit_buddy_mobile/core/usecase/usecase_interface.dart';
import 'package:uit_buddy_mobile/features/profile/domain/entities/semester_detail_entity.dart';
import 'package:uit_buddy_mobile/features/profile/domain/repositories/semester_detail_repository.dart';

class GetSemesterDetailsUsecase implements UseCase<List<SemesterDetailEntity>, NoParams> {
  GetSemesterDetailsUsecase({required SemesterDetailRepository semesterDetailRepository}) : _semesterDetailRepository = semesterDetailRepository;

  final SemesterDetailRepository _semesterDetailRepository;
  
  @override
  Future<Either<Failure, List<SemesterDetailEntity>>> call(NoParams params) async =>
    _semesterDetailRepository.getSemesterDetail();

}
import 'package:fpdart/fpdart.dart';
import 'package:uit_buddy_mobile/core/error/failures.dart';
import 'package:uit_buddy_mobile/core/usecase/usecase_interface.dart';
import 'package:uit_buddy_mobile/features/storage/domain/entities/subject_class_entity.dart';
import 'package:uit_buddy_mobile/features/storage/domain/repositories/subject_class_repository.dart';

class SubjectClassUsecase implements UseCase<List<SubjectClassEntity>, NoParams> {
  SubjectClassUsecase({required SubjectClassRepository subjectClassRepository})
    : _subjectClassRepository = subjectClassRepository;
  final SubjectClassRepository _subjectClassRepository;
  @override
  Future<Either<Failure, List<SubjectClassEntity>>> call(
    NoParams params,
  ) async => _subjectClassRepository.getClasses();
}

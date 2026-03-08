import 'package:fpdart/fpdart.dart';
import 'package:uit_buddy_mobile/core/error/failures.dart';
import 'package:uit_buddy_mobile/features/storage/domain/entities/subject_class_entity.dart';

abstract interface class SubjectClassRepository {
  Future<Either<Failure, List<SubjectClassEntity>>> getClasses();
}

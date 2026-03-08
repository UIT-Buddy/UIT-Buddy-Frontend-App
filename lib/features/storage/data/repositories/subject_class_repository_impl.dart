import 'package:fpdart/fpdart.dart';
import 'package:uit_buddy_mobile/core/error/failures.dart';
import 'package:uit_buddy_mobile/features/storage/data/datasources/subject_class_datasource_interface.dart';
import 'package:uit_buddy_mobile/features/storage/data/mapper/subject_class_mapper.dart';
import 'package:uit_buddy_mobile/features/storage/domain/entities/subject_class_entity.dart';
import 'package:uit_buddy_mobile/features/storage/domain/repositories/subject_class_repository.dart';

class SubjectClassRepositoryImpl implements SubjectClassRepository {
  SubjectClassRepositoryImpl({
    required SubjectClassDatasourceInterface subjectClassDatasourceInterface,
  }) : _subjectClassDatasourceInterface = subjectClassDatasourceInterface;

  final SubjectClassDatasourceInterface _subjectClassDatasourceInterface;

  @override
  Future<Either<Failure, List<SubjectClassEntity>>> getClasses() async {
    try {
      final response = await _subjectClassDatasourceInterface.getClasses();
      if (response.data == null) {
        return Left(Failure(response.message));
      }
      return Right(response.data!.map((e) => e.toEntity()).toList());
    } on Exception catch (e) {
      return Left(Failure.fromException(e));
    }
  }
}

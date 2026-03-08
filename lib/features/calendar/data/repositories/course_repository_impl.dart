import 'package:fpdart/fpdart.dart';
import 'package:uit_buddy_mobile/core/error/failures.dart';
import 'package:uit_buddy_mobile/features/calendar/data/datasources/course_datasource_interface.dart';
import 'package:uit_buddy_mobile/features/calendar/data/mapper/course_mapper.dart';
import 'package:uit_buddy_mobile/features/calendar/domain/entities/course_entity.dart';
import 'package:uit_buddy_mobile/features/calendar/domain/repositories/course_repository.dart';

class CourseRepositoryImpl implements CourseRepository {
  CourseRepositoryImpl({
    required CourseDatasourceInterface courseDatasourceInterface,
  }) : _courseDatasourceInterface = courseDatasourceInterface;

  final CourseDatasourceInterface _courseDatasourceInterface;

  @override
  Future<Either<Failure, List<CourseEntity>>> getCourses() async {
    try {
      final models = await _courseDatasourceInterface.getCourses();
      return Right(models.map((m) => m.toEntity()).toList());
    } on Exception catch (e) {
      return Left(Failure.fromException(e));
    }
  }
}

import 'dart:developer';

import 'package:fpdart/fpdart.dart';
import 'package:uit_buddy_mobile/core/error/failures.dart';
import 'package:uit_buddy_mobile/features/calendar/data/datasources/course_datasource_interface.dart';
import 'package:uit_buddy_mobile/features/calendar/data/mapper/course_details_mapper.dart';
import 'package:uit_buddy_mobile/features/calendar/data/mapper/course_mapper.dart';
import 'package:uit_buddy_mobile/features/calendar/domain/entities/course_content_entity.dart';
import 'package:uit_buddy_mobile/features/calendar/domain/entities/course_details_entity.dart';
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
      // ignore: avoid_catches_without_on_clauses
    } catch (e, st) {
      log('getCourses error: $e', stackTrace: st, name: 'CourseRepository');
      return Left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<CourseDetailsEntity>>> getCoursesByMode({
    required int semester,
    required int year,
  }) async {
    try {
      final models = await _courseDatasourceInterface.getCoursesByMode(
        semester: semester,
        year: year,
      );
      return Right(models.map((m) => m.toEntity()).toList());
      // ignore: avoid_catches_without_on_clauses
    } catch (e, st) {
      log(
        'getCoursesByMode error: $e',
        stackTrace: st,
        name: 'CourseRepository',
      );
      return Left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<CourseDetailsEntity>>> uploadSchedule({
    required String filePath,
    required String fileName,
  }) async {
    try {
      final models = await _courseDatasourceInterface.uploadSchedule(
        filePath: filePath,
        fileName: fileName,
      );
      return Right(models.map((m) => m.toEntity()).toList());
      // ignore: avoid_catches_without_on_clauses
    } catch (e, st) {
      log('uploadSchedule error: $e', stackTrace: st, name: 'CourseRepository');
      return Left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<CourseDetailsEntity>>> syncAssignments({
    int? month,
    int? year,
  }) async {
    try {
      final models = await _courseDatasourceInterface.syncAssignments(
        month: month,
        year: year,
      );
      return Right(models.map((m) => m.toEntity()).toList());
      // ignore: avoid_catches_without_on_clauses
    } catch (e, st) {
      log(
        'syncAssignments error: $e',
        stackTrace: st,
        name: 'CourseRepository',
      );
      return Left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, CourseContentEntity>> syncCourseAssignments({
    required String classId,
    int? month,
    int? year,
  }) async {
    try {
      final model = await _courseDatasourceInterface.syncCourseAssignments(
        classId: classId,
        month: month,
        year: year,
      );
      return Right(
        CourseContentEntity(
          courseName: model.courseName,
          exercises: model.exercises.map((d) => d.toEntity()).toList(),
        ),
      );
      // ignore: avoid_catches_without_on_clauses
    } catch (e, st) {
      log(
        'syncCourseAssignments error: $e',
        stackTrace: st,
        name: 'CourseRepository',
      );
      return Left(Failure(e.toString()));
    }
  }
}

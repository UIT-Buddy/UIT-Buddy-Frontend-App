import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:fpdart/fpdart.dart';
import 'package:uit_buddy_mobile/core/error/failures.dart';
import 'package:uit_buddy_mobile/core/usecase/usecase_interface.dart';
import 'package:uit_buddy_mobile/features/calendar/domain/entities/course_details_entity.dart';
import 'package:uit_buddy_mobile/features/calendar/domain/repositories/course_repository.dart';

class GetCoursesModeUsecase
    implements UseCase<List<CourseDetailsEntity>, GetCoursesModeParams> {
  GetCoursesModeUsecase({required CourseRepository courseRepository})
    : _courseRepository = courseRepository;

  final CourseRepository _courseRepository;

  @override
  Future<Either<Failure, List<CourseDetailsEntity>>> call(
    GetCoursesModeParams params,
  ) {
    return _courseRepository.getCoursesByMode(
      semester: params.semester,
      year: params.year,
    );
  }
}

@immutable
class GetCoursesModeParams extends Equatable {
  const GetCoursesModeParams({required this.semester, required this.year});
  final int semester; // 1 or 2
  final int year;
  @override
  List<Object?> get props => [semester, year];
}

import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';
import 'package:uit_buddy_mobile/core/error/failures.dart';
import 'package:uit_buddy_mobile/core/usecase/usecase_interface.dart';
import 'package:uit_buddy_mobile/features/calendar/domain/entities/course_details_entity.dart';
import 'package:uit_buddy_mobile/features/calendar/domain/repositories/course_repository.dart';

class UploadScheduleUsecase
    implements UseCase<List<CourseDetailsEntity>, UploadScheduleParams> {
  UploadScheduleUsecase({required CourseRepository courseRepository})
    : _courseRepository = courseRepository;

  final CourseRepository _courseRepository;

  @override
  Future<Either<Failure, List<CourseDetailsEntity>>> call(
    UploadScheduleParams params,
  ) {
    return _courseRepository.uploadSchedule(
      filePath: params.filePath,
      fileName: params.fileName,
    );
  }
}

class UploadScheduleParams extends Equatable {
  const UploadScheduleParams({required this.filePath, required this.fileName});

  final String filePath;
  final String fileName;

  @override
  List<Object?> get props => [filePath, fileName];
}

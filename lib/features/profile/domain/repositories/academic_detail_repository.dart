import 'package:fpdart/fpdart.dart';
import 'package:uit_buddy_mobile/core/error/failures.dart';
import 'package:uit_buddy_mobile/features/profile/domain/entities/academic_detail_entity.dart';

abstract interface class AcademicDetailRepository {
  Future<Either<Failure, AcademicDetailEntity>> getAcademicDetail();
}
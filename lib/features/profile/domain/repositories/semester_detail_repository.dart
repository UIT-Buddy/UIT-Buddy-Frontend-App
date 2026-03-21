import 'package:fpdart/fpdart.dart';
import 'package:uit_buddy_mobile/core/error/failures.dart';
import 'package:uit_buddy_mobile/features/profile/domain/entities/semester_detail_entity.dart';

abstract interface class SemesterDetailRepository {
  Future<Either<Failure, List<SemesterDetailEntity>>> getSemesterDetail();
}

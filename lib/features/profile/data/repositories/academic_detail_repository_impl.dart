import 'package:fpdart/fpdart.dart';
import 'package:uit_buddy_mobile/core/error/failures.dart';
import 'package:uit_buddy_mobile/features/profile/domain/entities/academic_detail_entity.dart';
import 'package:uit_buddy_mobile/features/profile/domain/repositories/academic_detail_repository.dart';

class AcademicDetailRepositoryImpl implements AcademicDetailRepository {
  @override
  Future<Either<Failure, AcademicDetailEntity>> getAcademicDetail() async {
    // Return mock data after a short delay
    await Future.delayed(const Duration(milliseconds: 500));

    return const Right(
      AcademicDetailEntity(
        attemptedCredits: 91,
        accumulatedCredits: 103,
        generalCredits: 43,
        foundationCredits: 45,
        majorCredits: 0,
        graduationCredits: 0,
        majorProgress: 79.0,
        currentGpa: 3.2,
        targetGpa: 4.0,
      ),
    );
  }
}

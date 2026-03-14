import 'package:fpdart/fpdart.dart';
import 'package:uit_buddy_mobile/core/error/failures.dart';
import 'package:uit_buddy_mobile/features/profile/domain/entities/semester_detail_entity.dart';
import 'package:uit_buddy_mobile/features/profile/domain/repositories/semester_detail_repository.dart';

class SemesterDetailRepositoryImpl implements SemesterDetailRepository {
  @override
  Future<Either<Failure, List<SemesterDetailEntity>>> getSemesterDetail() async {
    // Return mock data after a short delay
    await Future.delayed(const Duration(milliseconds: 500));
    
    return Right([
      SemesterDetailEntity(
        id: '1',
        yearStart: 2025,
        yearEnd: 2026,
        gpa: 3.2,
        credits: 19,
        startDate: DateTime(2026, 1, 26),
        endDate: DateTime(2026, 6, 1),
        isCurrent: true,
        rank: 'Good',
        semesterNumber: 2,
      ),
      SemesterDetailEntity(
        id: '2',
        yearStart: 2025,
        yearEnd: 2026,
        gpa: 3.2,
        credits: 19,
        startDate: DateTime(2025, 9, 8),
        endDate: DateTime(2025, 12, 29),
        isCurrent: false,
        rank: 'Good',
        semesterNumber: 1,
      ),
      SemesterDetailEntity(
        id: '3',
        yearStart: 2024,
        yearEnd: 2025,
        gpa: 3.0,
        credits: 18,
        startDate: DateTime(2025, 1, 25),
        endDate: DateTime(2025, 6, 5),
        isCurrent: false,
        rank: 'Good',
        semesterNumber: 2,
      ),
    ]);
  }
}

import 'package:uit_buddy_mobile/features/profile/data/models/academic_detail_model.dart';
import 'package:uit_buddy_mobile/features/profile/domain/entities/academic_detail_entity.dart';

extension AcademicDetailMapper on AcademicDetailModel {
  AcademicDetailEntity toEntity() => AcademicDetailEntity(
    attemptedCredits: attemptedCredits,
    accumulatedCredits: accumulatedCredits,
    attemptedGpaScale10: attemptedGpaScale10,
    attemptedGpaScale4: attemptedGpaScale4,
    accumulatedGpaScale10: accumulatedGpaScale10,
    accumulatedGpaScale4: accumulatedGpaScale4,
    accumulatedGeneralCredits: accumulatedGeneralCredits,
    accumulatedFoundationCredits: accumulatedFoundationCredits,
    accumulatedMajorCredits: accumulatedMajorCredits,
    accumulatedGraduationCredits: accumulatedGraduationCredits,
    accumulatedElectiveCredits: accumulatedElectiveCredits,
    accumulatedPoliticalCredits: accumulatedPoliticalCredits,
    majorProgress: majorProgress,
  );
}

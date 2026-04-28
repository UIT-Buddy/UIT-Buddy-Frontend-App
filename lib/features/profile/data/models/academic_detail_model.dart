import 'package:freezed_annotation/freezed_annotation.dart';

part 'academic_detail_model.freezed.dart';
part 'academic_detail_model.g.dart';

@freezed
abstract class AcademicDetailModel with _$AcademicDetailModel {
  const factory AcademicDetailModel({
    required int attemptedCredits,
    required int accumulatedCredits,
    required double attemptedGpaScale10,
    required double attemptedGpaScale4,
    required double accumulatedGpaScale10,
    required double accumulatedGpaScale4,
    required int accumulatedGeneralCredits,
    required int accumulatedFoundationCredits,
    required int accumulatedMajorCredits,
    required int accumulatedGraduationCredits,
    required int accumulatedElectiveCredits,
    required int accumulatedPoliticalCredits,
    required double majorProgress,
  }) = _AcademicDetailModel;

  factory AcademicDetailModel.fromJson(Map<String, dynamic> json) =>
      _$AcademicDetailModelFromJson(json);
}

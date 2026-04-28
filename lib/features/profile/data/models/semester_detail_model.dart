import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:uit_buddy_mobile/features/profile/data/models/grade_model.dart';

part 'semester_detail_model.freezed.dart';
part 'semester_detail_model.g.dart';

@freezed
abstract class SemesterDetailModel with _$SemesterDetailModel {
  const factory SemesterDetailModel({
    required String id,
    required int accumulatedCredits,
    required double averageGradeScale10,
    required double averageGradeScale4,
    required List<GradeModel> grades,
    required int totalCredits,
    required List<int> totalCreditsByCategory,
  }) = _SemesterDetailModel;

  factory SemesterDetailModel.fromJson(Map<String, dynamic> json) =>
      _$SemesterDetailModelFromJson(json);
}

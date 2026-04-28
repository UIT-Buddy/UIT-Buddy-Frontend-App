import 'package:freezed_annotation/freezed_annotation.dart';

part 'grade_model.freezed.dart';
part 'grade_model.g.dart';

@freezed
abstract class GradeModel with _$GradeModel {
  const factory GradeModel({
    required String id,
    required String courseCode,
    required String courseName,
    required String courseType,
    required double finalGrade,
    required double labGrade,
    required double midtermGrade,
    required double processGrade,
    required double totalGrade,
    required int credits,
  }) = _GradeModel;

  factory GradeModel.fromJson(Map<String, dynamic> json) =>
      _$GradeModelFromJson(json);
}

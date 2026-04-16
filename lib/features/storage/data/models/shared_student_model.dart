import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:uit_buddy_mobile/features/storage/data/models/student_model.dart';

part 'shared_student_model.freezed.dart';
part 'shared_student_model.g.dart';

@freezed
abstract class SharedStudentModel with _$SharedStudentModel {
  const factory SharedStudentModel({
    required StudentModel student,
    required String accessRole,
    required DateTime sharedAt,
  }) = _SharedStudentModel;

  factory SharedStudentModel.fromJson(Map<String, dynamic> json) =>
      _$SharedStudentModelFromJson(json);
}

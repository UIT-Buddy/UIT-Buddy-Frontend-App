import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:uit_buddy_mobile/features/deadline/domain/entities/deadline_entity.dart';

part 'deadline_model.freezed.dart';
part 'deadline_model.g.dart';

@freezed
abstract class DeadlineModel with _$DeadlineModel {
  const DeadlineModel._();

  const factory DeadlineModel({
    required String id,
    required String exerciseName,
    required DateTime dueDate,
    String? url,
    required String status,
    required bool isPersonal,
  }) = _DeadlineModel;

  factory DeadlineModel.fromJson(Map<String, dynamic> json) =>
      _$DeadlineModelFromJson(json);

  DeadlineEntity toEntity() {
    return DeadlineEntity(
      id: id,
      exerciseName: exerciseName,
      dueDate: dueDate,
      url: url,
      status: status,
      isPersonal: isPersonal,
    );
  }
}

@freezed
abstract class CourseContentModel with _$CourseContentModel {
  const CourseContentModel._();

  const factory CourseContentModel({
    required String courseName,
    required List<DeadlineModel> exercises,
  }) = _CourseContentModel;

  factory CourseContentModel.fromJson(Map<String, dynamic> json) =>
      _$CourseContentModelFromJson(json);

  CourseContentEntity toEntity() {
    return CourseContentEntity(
      courseName: courseName,
      exercises: exercises.map((e) => e.toEntity()).toList(),
    );
  }
}

@freezed
abstract class DeadlineDataModel with _$DeadlineDataModel {
  const DeadlineDataModel._();

  const factory DeadlineDataModel({
    required int numberOfDeadlines,
    required List<CourseContentModel> courseContents,
  }) = _DeadlineDataModel;

  factory DeadlineDataModel.fromJson(Map<String, dynamic> json) =>
      _$DeadlineDataModelFromJson(json);

  DeadlineDataEntity toEntity() {
    return DeadlineDataEntity(
      numberOfDeadlines: numberOfDeadlines,
      courseContents: courseContents.map((e) => e.toEntity()).toList(),
    );
  }
}

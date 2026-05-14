import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:uit_buddy_mobile/features/deadline/domain/entities/deadline_entity.dart';

part 'deadline_model.freezed.dart';
part 'deadline_model.g.dart';

Object? _readExerciseName(Map json, String key) {
  return json['deadlineName'] ?? json['exerciseName'];
}

@freezed
abstract class DeadlineModel with _$DeadlineModel {
  const DeadlineModel._();

  const factory DeadlineModel({
    required String id,
    @JsonKey(readValue: _readExerciseName) required String exerciseName,
    required DateTime dueDate,
    String? url,
    required String status,
    required bool isPersonal,
    String? classCode,
  }) = _DeadlineModel;

  factory DeadlineModel.fromJson(Map<String, dynamic> json) =>
      _$DeadlineModelFromJson(json);

  DeadlineEntity toEntity() {
    return DeadlineEntity(
      id: id,
      exerciseName: exerciseName,
      dueDate: dueDate,
      url: url,
      status: _deadlineStatusFromString(status),
      isPersonal: isPersonal,
      classCode: classCode,
    );
  }
}

DeadlineStatus _deadlineStatusFromString(String status) {
  switch (status.toUpperCase()) {
    case 'DONE':
      return DeadlineStatus.done;
    case 'UPCOMING':
      return DeadlineStatus.upcoming;
    case 'OVERDUE':
      return DeadlineStatus.overdue;
    case 'NEARDEADLINE':
      return DeadlineStatus.nearDeadline;
    default:
      throw ArgumentError('Unknown deadline status: $status');
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

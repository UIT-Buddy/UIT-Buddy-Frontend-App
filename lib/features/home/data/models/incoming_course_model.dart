import 'package:freezed_annotation/freezed_annotation.dart';

part 'incoming_course_model.freezed.dart';
part 'incoming_course_model.g.dart';

@freezed
abstract class IncomingCourseModel with _$IncomingCourseModel {
  const factory IncomingCourseModel({
    required int remainingTime,
    required int studentsInClass,
    required String courseCode,
    required String courseName,
    required String roomCode,
    required String lecturerName,
  }) = _IncomingCourseModel;

  factory IncomingCourseModel.fromJson(Map<String, dynamic> json) =>
      _$IncomingCourseModelFromJson(json);
}

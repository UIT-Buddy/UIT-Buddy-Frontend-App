import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:uit_buddy_mobile/features/calendar/domain/entities/course_details_entity.dart';

part 'courses_mode_state.freezed.dart';

enum CoursesModeStatus { initial, loading, loaded, error }

@freezed
abstract class CoursesModeState with _$CoursesModeState {
  const factory CoursesModeState({
    @Default(CoursesModeStatus.initial) CoursesModeStatus status,
    @Default([]) List<CourseDetailsEntity> courses,
    @Default(2) int semester,
    @Default(2026) int year,
    String? errorMessage,
  }) = _CoursesModeState;
}

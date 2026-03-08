import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:uit_buddy_mobile/features/calendar/domain/entities/course_entity.dart';

part 'add_deadline_state.freezed.dart';

enum AddDeadlineStatus { initial, loading, created, error }

@freezed
abstract class AddDeadlineState with _$AddDeadlineState {
  const factory AddDeadlineState({
    @Default(AddDeadlineStatus.initial) AddDeadlineStatus status,
    @Default(<CourseEntity>[]) List<CourseEntity> allCourses,
    @Default(<CourseEntity>[]) List<CourseEntity> suggestions,
    String? errorMessage,
  }) = _AddDeadlineState;
}

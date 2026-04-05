import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:uit_buddy_mobile/features/calendar/domain/entities/course_details_entity.dart';

part 'courses_mode_state.freezed.dart';

enum CoursesModeStatus { initial, loading, loaded, error }

enum UploadScheduleStatus { idle, loading, success, failure }

enum SyncAssignmentsStatus { idle, syncing, synced, failure }

@freezed
abstract class CoursesModeState with _$CoursesModeState {
  const factory CoursesModeState({
    @Default(CoursesModeStatus.initial) CoursesModeStatus status,
    @Default([]) List<CourseDetailsEntity> courses,
    @Default(2) int semester,
    @Default(2026) int year,
    String? errorMessage,
    @Default(UploadScheduleStatus.idle) UploadScheduleStatus uploadStatus,
    String? uploadErrorMessage,
    @Default(SyncAssignmentsStatus.idle)
    SyncAssignmentsStatus syncAssignmentsStatus,
    String? syncAssignmentsErrorMessage,

    /// Which classId is currently loading its per-course deadlines.
    String? loadingCourseClassId,

    /// Cached deadlines fetched per course (keyed by classId).
    @Default({}) Map<String, List<DeadlineDetailEntity>> courseDeadlines,
  }) = _CoursesModeState;
}

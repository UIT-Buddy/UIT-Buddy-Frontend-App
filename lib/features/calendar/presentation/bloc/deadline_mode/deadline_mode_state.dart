import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:uit_buddy_mobile/features/calendar/domain/entities/calendar_deadline_entity.dart';

part 'deadline_mode_state.freezed.dart';

enum DeadlineModeStatus { initial, loading, loaded, error }

@freezed
abstract class DeadlineModeState with _$DeadlineModeState {
  const factory DeadlineModeState({
    @Default(DeadlineModeStatus.initial) DeadlineModeStatus status,
    @Default(null) CalendarDeadlineEntity? calendarDeadlineEntity,
    String? errorMessage,
  }) = _DeadlineModeState;
}

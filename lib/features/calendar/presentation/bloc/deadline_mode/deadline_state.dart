import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:uit_buddy_mobile/features/calendar/domain/entities/calendar_deadline_entity.dart';

part 'deadline_state.freezed.dart';

enum DeadlineModeStatus { initial, loading, loaded, error }

@freezed
abstract class DeadlineState with _$DeadlineState {
  const factory DeadlineState({
    @Default(DeadlineModeStatus.initial) DeadlineModeStatus status,
    @Default(null) CalendarDeadlineEntity? calendarDeadlineEntity,
    String? errorMessage,
  }) = _DeadlineState;
}

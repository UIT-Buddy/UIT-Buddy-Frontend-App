import 'package:freezed_annotation/freezed_annotation.dart';

part 'calendar_state.freezed.dart';

enum CalendarStatus { initial, loading, loaded, error }

enum CalendarMode { deadline, courses }

@freezed
abstract class CalendarState with _$CalendarState {
  const factory CalendarState({
    @Default(CalendarStatus.initial) CalendarStatus status,
    int? month,
    int? year,
    @Default(CalendarMode.deadline) CalendarMode mode,
    String? errorMessage,
  }) = _CalendarState;
}

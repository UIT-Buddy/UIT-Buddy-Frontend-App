import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uit_buddy_mobile/features/calendar/presentation/bloc/calendar_screen/calendar_event.dart';
import 'package:uit_buddy_mobile/features/calendar/presentation/bloc/calendar_screen/calendar_state.dart';

class CalendarBloc extends Bloc<CalendarEvent, CalendarState> {
  CalendarBloc() : super(const CalendarState()) {
    on<CalendarStarted>(_onCalendarStarted);
    on<ToggleCalendarMode>(_onToggleCalendarMode);
    on<SelectDeadlineMode>(_onSelectDeadlineMode);
    on<SelectCoursesMode>(_onSelectCoursesMode);
  }

  void _onCalendarStarted(CalendarStarted event, Emitter<CalendarState> emit) {
    // Handle initial loading if needed
  }

  void _onToggleCalendarMode(
    ToggleCalendarMode event,
    Emitter<CalendarState> emit,
  ) {
    final newMode = state.mode == CalendarMode.deadline
        ? CalendarMode.courses
        : CalendarMode.deadline;

    emit(state.copyWith(mode: newMode));
  }

  void _onSelectDeadlineMode(
    SelectDeadlineMode event,
    Emitter<CalendarState> emit,
  ) {
    emit(state.copyWith(mode: CalendarMode.deadline));
  }

  void _onSelectCoursesMode(
    SelectCoursesMode event,
    Emitter<CalendarState> emit,
  ) {
    emit(state.copyWith(mode: CalendarMode.courses));
  }
}

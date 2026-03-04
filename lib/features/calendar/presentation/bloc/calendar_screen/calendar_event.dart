import 'package:equatable/equatable.dart';

abstract class CalendarEvent extends Equatable {
  const CalendarEvent();

  @override
  List<Object?> get props => [];
}

class CalendarStarted extends CalendarEvent {
  const CalendarStarted();
}

class ToggleCalendarMode extends CalendarEvent {
  const ToggleCalendarMode();
}

class SelectDeadlineMode extends CalendarEvent {
  const SelectDeadlineMode();
}

class SelectCoursesMode extends CalendarEvent {
  const SelectCoursesMode();
}

class NextMonthEvent extends CalendarEvent {
  const NextMonthEvent();
}

class PreviousMonthEvent extends CalendarEvent {
  const PreviousMonthEvent();
}

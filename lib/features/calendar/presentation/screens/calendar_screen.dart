import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uit_buddy_mobile/app/di/app_dependencies.dart';
import 'package:uit_buddy_mobile/features/calendar/presentation/bloc/calendar_screen/calendar_bloc.dart';
import 'package:uit_buddy_mobile/features/calendar/presentation/bloc/calendar_screen/calendar_event.dart';
import 'package:uit_buddy_mobile/features/calendar/presentation/bloc/calendar_screen/calendar_state.dart';
import 'package:uit_buddy_mobile/features/calendar/presentation/bloc/deadline_mode/deadline_bloc.dart';
import 'package:uit_buddy_mobile/features/calendar/presentation/bloc/deadline_mode/deadline_event.dart';
import 'package:uit_buddy_mobile/features/calendar/presentation/bloc/deadline_mode/deadline_state.dart';
import 'package:uit_buddy_mobile/features/calendar/presentation/widgets/calendar_screen_header.dart';
import 'package:uit_buddy_mobile/features/calendar/presentation/widgets/courses_mode/courses_calendar_widget.dart';
import 'package:uit_buddy_mobile/features/calendar/presentation/widgets/deadline_mode/deadline_calendar_widget.dart';
import 'package:uit_buddy_mobile/features/calendar/presentation/widgets/deadline_mode/deadline_detail_section.dart';

class CalendarScreen extends StatelessWidget {
  const CalendarScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) =>
              serviceLocator<CalendarBloc>()..add(const CalendarStarted()),
        ),
        BlocProvider(
          create: (context) =>
              serviceLocator<DeadlineBloc>()..add(const DeadlineStarted()),
        ),
      ],
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.only(top: 40, left: 15, right: 15),
          child: Column(
            children: [
              const CalendarScreenHeaderWidget(),
              Expanded(
                child: BlocBuilder<CalendarBloc, CalendarState>(
                  builder: (context, state) {
                    switch (state.mode) {
                      case CalendarMode.deadline:
                        return BlocBuilder<DeadlineBloc, DeadlineState>(
                          builder: (context, deadlineState) {
                            // Get selected day's deadline details
                            final selectedItem = deadlineState
                                .calendarDeadlineEntity
                                ?.items
                                .where((item) => item.isSelected)
                                .firstOrNull;

                            final deadlineDetails = selectedItem?.details ?? [];

                            return Column(
                              children: [
                                const DeadlineCalendarWidget(),
                                Expanded(
                                  child: DeadlineDetailSection(
                                    deadlineDetails: deadlineDetails,
                                  ),
                                ),
                              ],
                            );
                          },
                        );
                      case CalendarMode.courses:
                        return const CoursesCalendarWidget();
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

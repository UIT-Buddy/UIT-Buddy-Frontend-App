import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uit_buddy_mobile/app/di/app_dependencies.dart';
import 'package:uit_buddy_mobile/core/theme/app_color.dart';
import 'package:uit_buddy_mobile/features/calendar/presentation/bloc/calendar_screen/calendar_bloc.dart';
import 'package:uit_buddy_mobile/features/calendar/presentation/bloc/calendar_screen/calendar_event.dart';
import 'package:uit_buddy_mobile/features/calendar/presentation/bloc/calendar_screen/calendar_state.dart';
import 'package:uit_buddy_mobile/features/calendar/presentation/bloc/courses_mode/courses_mode_bloc.dart';
import 'package:uit_buddy_mobile/features/calendar/presentation/bloc/courses_mode/courses_mode_event.dart';
import 'package:uit_buddy_mobile/features/calendar/presentation/bloc/deadline_mode/deadline_bloc.dart';
import 'package:uit_buddy_mobile/features/calendar/presentation/bloc/deadline_mode/deadline_event.dart';
import 'package:uit_buddy_mobile/features/calendar/presentation/bloc/deadline_mode/deadline_state.dart';
import 'package:uit_buddy_mobile/features/calendar/presentation/widgets/calendar_screen_header.dart';
import 'package:uit_buddy_mobile/features/calendar/presentation/widgets/courses_mode/courses_calendar_widget.dart';
import 'package:uit_buddy_mobile/features/calendar/presentation/widgets/deadline_mode/deadline_calendar_widget.dart';
import 'package:uit_buddy_mobile/features/calendar/presentation/widgets/deadline_mode/deadline_detail_section.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  Future<void> _onRefresh(BuildContext context, CalendarMode mode) async {
    if (mode == CalendarMode.deadline) {
      context.read<DeadlineBloc>().add(const DeadlineStarted());
    } else {
      context.read<CoursesModeBloc>().add(const CoursesModeStarted());
    }
    // Give the bloc a moment to process before dismissing the indicator
    await Future.delayed(const Duration(milliseconds: 800));
  }

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
        BlocProvider(
          create: (context) =>
              serviceLocator<CoursesModeBloc>()
                ..add(const CoursesModeStarted()),
        ),
      ],
      child: Scaffold(
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: MediaQuery.of(context).size.width * 0.04,
            ),
            child: Column(
              children: [
                const CalendarScreenHeaderWidget(),
                Expanded(
                  child: BlocBuilder<CalendarBloc, CalendarState>(
                    builder: (context, state) {
                      return RefreshIndicator(
                        color: AppColor.primaryBlue,
                        onRefresh: () => _onRefresh(context, state.mode),
                        child: switch (state.mode) {
                          CalendarMode.deadline =>
                            BlocBuilder<DeadlineBloc, DeadlineState>(
                              builder: (context, deadlineState) {
                                final selectedItem = deadlineState
                                    .calendarDeadlineEntity
                                    ?.items
                                    .where((item) => item.isSelected)
                                    .firstOrNull;

                                final deadlineDetails =
                                    selectedItem?.details ?? [];

                                return Column(
                                  children: [
                                    const DeadlineCalendarWidget(),
                                    Expanded(
                                      child: DeadlineDetailSection(
                                        deadlineDetails: deadlineDetails,
                                        selectedDay: selectedItem?.day,
                                        month: deadlineState
                                            .calendarDeadlineEntity
                                            ?.month,
                                        year: deadlineState
                                            .calendarDeadlineEntity
                                            ?.year,
                                      ),
                                    ),
                                  ],
                                );
                              },
                            ),
                          CalendarMode.courses => const CoursesCalendarWidget(),
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

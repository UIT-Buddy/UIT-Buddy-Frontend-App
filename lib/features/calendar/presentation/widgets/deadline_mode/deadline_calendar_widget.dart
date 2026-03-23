import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uit_buddy_mobile/core/theme/app_color.dart';
import 'package:uit_buddy_mobile/features/calendar/presentation/bloc/deadline_mode/deadline_bloc.dart';
import 'package:uit_buddy_mobile/features/calendar/presentation/bloc/deadline_mode/deadline_event.dart';
import 'package:uit_buddy_mobile/features/calendar/presentation/bloc/deadline_mode/deadline_state.dart';
import 'package:uit_buddy_mobile/features/calendar/presentation/widgets/deadline_mode/deadline_calendar_grid.dart';
import 'package:uit_buddy_mobile/features/calendar/presentation/widgets/deadline_mode/deadline_day_name_widget.dart';
import 'package:uit_buddy_mobile/features/calendar/presentation/widgets/deadline_mode/deadline_header.dart';

class DeadlineCalendarWidget extends StatelessWidget {
  const DeadlineCalendarWidget({super.key});

  @override
  Widget build(BuildContext context) =>
      BlocBuilder<DeadlineBloc, DeadlineState>(
        builder: (context, state) {
          final screenWidth = MediaQuery.of(context).size.width;
          final hPad = screenWidth * 0.045;
          final radius = screenWidth * 0.065;
          return Container(
            margin: const EdgeInsets.symmetric(vertical: 6),
            decoration: BoxDecoration(
              color: AppColor.pureWhite,
              borderRadius: BorderRadius.circular(radius),
              boxShadow: [
                BoxShadow(
                  color: AppColor.primaryBlue.withValues(alpha: 0.10),
                  blurRadius: 20,
                  offset: const Offset(0, 6),
                ),
                BoxShadow(
                  color: AppColor.shadowColor,
                  blurRadius: 4,
                  offset: const Offset(0, 1),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (state.calendarDeadlineEntity != null) ...[
                  // Gradient header strip
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: hPad,
                      vertical: hPad * 0.75,
                    ),
                    decoration: BoxDecoration(
                      gradient: AppColor.primaryGradient,
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(radius),
                      ),
                    ),
                    child: DeadlineHeader(
                      month: state.calendarDeadlineEntity!.month,
                      year: state.calendarDeadlineEntity!.year,
                      onPreviousMonth: () => context.read<DeadlineBloc>().add(
                        const DeadlinePreviousMonthSelected(),
                      ),
                      onNextMonth: () => context.read<DeadlineBloc>().add(
                        const DeadlineNextMonthSelected(),
                      ),
                    ),
                  ),
                  // Day names + grid
                  Padding(
                    padding: EdgeInsets.fromLTRB(hPad, hPad * 0.7, hPad, hPad),
                    child: Column(
                      children: [
                        const DeadlineDayNameWidget(),
                        SizedBox(height: screenWidth * 0.025),
                        DeadlineCalendarGrid(
                          month: state.calendarDeadlineEntity!.month,
                          year: state.calendarDeadlineEntity!.year,
                          items: state.calendarDeadlineEntity!.items,
                        ),
                      ],
                    ),
                  ),
                ],
                if (state.status == DeadlineModeStatus.loading)
                  const Padding(
                    padding: EdgeInsets.all(24),
                    child: Center(child: CircularProgressIndicator()),
                  ),
                if (state.status == DeadlineModeStatus.error &&
                    state.errorMessage != null)
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Center(child: Text(state.errorMessage!)),
                  ),
              ],
            ),
          );
        },
      );
}

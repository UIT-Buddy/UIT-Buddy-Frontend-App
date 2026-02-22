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
        builder: (context, state) => Container(
          margin: const EdgeInsets.all(20),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: AppColor.pureWhite,
            border: Border.all(color: AppColor.dividerGrey, width: 1),
            borderRadius: BorderRadius.circular(25),
            boxShadow: [
              BoxShadow(
                color: AppColor.shadowColor,
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              if (state.calendarDeadlineEntity != null) ...[
                DeadlineHeader(
                  month: state.calendarDeadlineEntity!.month,
                  year: state.calendarDeadlineEntity!.year,
                  onPreviousMonth: () {
                    context.read<DeadlineBloc>().add(
                      const DeadlinePreviousMonthSelected(),
                    );
                  },
                  onNextMonth: () {
                    context.read<DeadlineBloc>().add(
                      const DeadlineNextMonthSelected(),
                    );
                  },
                ),
                const SizedBox(height: 16),
                const DeadlineDayNameWidget(),
                const SizedBox(height: 12),
                DeadlineCalendarGrid(
                  month: state.calendarDeadlineEntity!.month,
                  year: state.calendarDeadlineEntity!.year,
                  items: state.calendarDeadlineEntity!.items,
                ),
              ],
              if (state.status == DeadlineModeStatus.loading)
                const Center(child: CircularProgressIndicator()),
              if (state.status == DeadlineModeStatus.error &&
                  state.errorMessage != null)
                Center(child: Text(state.errorMessage!)),
            ],
          ),
        ),
      );
}

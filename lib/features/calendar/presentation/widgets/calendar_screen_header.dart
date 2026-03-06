import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uit_buddy_mobile/core/theme/app_color.dart';
import 'package:uit_buddy_mobile/core/theme/app_text_style.dart';
import 'package:uit_buddy_mobile/features/calendar/presentation/bloc/calendar_screen/calendar_bloc.dart';
import 'package:uit_buddy_mobile/features/calendar/presentation/bloc/calendar_screen/calendar_event.dart';
import 'package:uit_buddy_mobile/features/calendar/presentation/bloc/calendar_screen/calendar_state.dart';
import 'package:uit_buddy_mobile/features/calendar/presentation/constants/calendar_text.dart';

class CalendarScreenHeaderWidget extends StatelessWidget {
  const CalendarScreenHeaderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CalendarBloc, CalendarState>(
      builder: (context, state) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              CalendarText.calendarTitle,
              style: AppTextStyle.h1.copyWith(fontWeight: AppTextStyle.bold),
            ),
            Container(
              decoration: BoxDecoration(
                color: AppColor.veryLightGrey,
                borderRadius: BorderRadius.circular(8),
              ),
              padding: const EdgeInsets.all(4),
              child: Row(
                children: [
                  _buildToggleButton(
                    context: context,
                    text: CalendarText.deadlineMode,
                    isSelected: state.mode == CalendarMode.deadline,
                    onTap: () {
                      context.read<CalendarBloc>().add(
                        const SelectDeadlineMode(),
                      );
                    },
                  ),
                  const SizedBox(width: 4),
                  _buildToggleButton(
                    context: context,
                    text: CalendarText.coursesMode,
                    isSelected: state.mode == CalendarMode.courses,
                    onTap: () {
                      context.read<CalendarBloc>().add(
                        const SelectCoursesMode(),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildToggleButton({
    required BuildContext context,
    required String text,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: MediaQuery.of(context).size.width * 0.04,
          vertical: 8,
        ),
        decoration: BoxDecoration(
          color: isSelected ? AppColor.pureWhite : Colors.transparent,
          borderRadius: BorderRadius.circular(6),
        ),
        child: Text(
          text,
          style: AppTextStyle.captionLarge.copyWith(
            color: isSelected ? AppColor.primaryBlue : AppColor.secondaryText,
            fontWeight: AppTextStyle.medium,
          ),
        ),
      ),
    );
  }
}

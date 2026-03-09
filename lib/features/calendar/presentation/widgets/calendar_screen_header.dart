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
            _SlidingTabToggle(
              tabs: [CalendarText.deadlineMode, CalendarText.coursesMode],
              selectedIndex: state.mode == CalendarMode.deadline ? 0 : 1,
              onTabChanged: (index) {
                if (index == 0) {
                  context.read<CalendarBloc>().add(const SelectDeadlineMode());
                } else {
                  context.read<CalendarBloc>().add(const SelectCoursesMode());
                }
              },
            ),
          ],
        );
      },
    );
  }
}

class _SlidingTabToggle extends StatelessWidget {
  final List<String> tabs;
  final int selectedIndex;
  final ValueChanged<int> onTabChanged;

  static const double _itemWidth = 84.0;
  static const double _itemHeight = 36.0;
  static const double _padding = 3.0;

  const _SlidingTabToggle({
    required this.tabs,
    required this.selectedIndex,
    required this.onTabChanged,
  });

  @override
  Widget build(BuildContext context) {
    final double totalWidth = _itemWidth * tabs.length + _padding * 2;

    return Container(
      width: totalWidth,
      height: _itemHeight + _padding * 2,
      decoration: BoxDecoration(
        color: AppColor.veryLightGrey,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Stack(
        children: [
          // Sliding pill background
          AnimatedPositioned(
            duration: const Duration(milliseconds: 280),
            curve: Curves.easeInOutCubic,
            left: _padding + selectedIndex * _itemWidth,
            top: _padding,
            width: _itemWidth,
            height: _itemHeight,
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: AppColor.primaryBlue,
                borderRadius: BorderRadius.circular(18),
                boxShadow: [
                  BoxShadow(
                    color: AppColor.primaryBlue.withValues(alpha: 0.35),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
            ),
          ),
          // Tab labels
          Padding(
            padding: const EdgeInsets.all(_padding),
            child: Row(
              children: List.generate(tabs.length, (i) {
                final bool isSelected = selectedIndex == i;
                return GestureDetector(
                  onTap: () => onTabChanged(i),
                  behavior: HitTestBehavior.opaque,
                  child: SizedBox(
                    width: _itemWidth,
                    height: _itemHeight,
                    child: Center(
                      child: AnimatedDefaultTextStyle(
                        duration: const Duration(milliseconds: 220),
                        curve: Curves.easeInOut,
                        style: AppTextStyle.bodySmall.copyWith(
                          color: isSelected
                              ? AppColor.pureWhite
                              : AppColor.secondaryText,
                          fontWeight: isSelected
                              ? AppTextStyle.medium
                              : AppTextStyle.regular,
                        ),
                        child: Text(tabs[i]),
                      ),
                    ),
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}

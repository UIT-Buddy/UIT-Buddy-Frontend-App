import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uit_buddy_mobile/core/theme/app_color.dart';
import 'package:uit_buddy_mobile/features/calendar/domain/entities/calendar_deadline_entity.dart';
import 'package:uit_buddy_mobile/features/calendar/presentation/bloc/deadline_mode/deadline_bloc.dart';
import 'package:uit_buddy_mobile/features/calendar/presentation/bloc/deadline_mode/deadline_event.dart';

class DeadlineCalendarGrid extends StatelessWidget {
  const DeadlineCalendarGrid({
    super.key,
    required this.month,
    required this.year,
    required this.items,
  });

  final int month;
  final int year;
  final List<CalendarDeadlineItemEntity> items;

  int _getDaysInMonth(int month, int year) {
    return DateTime(year, month + 1, 0).day;
  }

  int _getFirstDayOfWeek(int month, int year) {
    // Returns 0 for Sunday, 1 for Monday, etc.
    return DateTime(year, month, 1).weekday % 7;
  }

  CalendarDeadlineItemEntity? _getItemForDay(int day) {
    try {
      return items.firstWhere((item) => item.day == day);
    } catch (e) {
      return null;
    }
  }

  Color _getStatusColor(CalendarDeadlineItemEntityStatus status) {
    switch (status) {
      case CalendarDeadlineItemEntityStatus.done:
        return AppColor.successGreen;
      case CalendarDeadlineItemEntityStatus.upcoming:
        return AppColor.primaryBlue;
      case CalendarDeadlineItemEntityStatus.nearDeadline:
      case CalendarDeadlineItemEntityStatus.overdue:
        return AppColor.alertRed;
      case CalendarDeadlineItemEntityStatus.empty:
        return Colors.transparent;
    }
  }

  @override
  Widget build(BuildContext context) {
    final daysInMonth = _getDaysInMonth(month, year);
    final firstDayOfWeek = _getFirstDayOfWeek(month, year);
    final totalCells = ((daysInMonth + firstDayOfWeek) / 7).ceil() * 7;

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 7,
        mainAxisSpacing: 8,
        crossAxisSpacing: 8,
      ),
      itemCount: totalCells,
      itemBuilder: (context, index) {
        final dayNumber = index - firstDayOfWeek + 1;

        // Empty cells before the first day
        if (index < firstDayOfWeek || dayNumber > daysInMonth) {
          return const SizedBox.shrink();
        }

        final item = _getItemForDay(dayNumber);
        final isSelected = item?.isSelected ?? false;
        final hasDeadline =
            item != null &&
            item.status != CalendarDeadlineItemEntityStatus.empty;

        return GestureDetector(
          onTap: () {
            context.read<DeadlineBloc>().add(DeadlineEntitySelected(dayNumber));
          },
          child: Container(
            decoration: BoxDecoration(
              color: isSelected ? AppColor.primaryBlue : Colors.transparent,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '$dayNumber',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: isSelected
                        ? AppColor.pureWhite
                        : AppColor.primaryText,
                  ),
                ),
                const SizedBox(height: 4),
                if (hasDeadline)
                  Container(
                    width: 6,
                    height: 6,
                    decoration: BoxDecoration(
                      color: isSelected
                          ? AppColor.pureWhite
                          : _getStatusColor(item.status),
                      shape: BoxShape.circle,
                    ),
                  )
                else
                  const SizedBox(height: 6),
              ],
            ),
          ),
        );
      },
    );
  }
}

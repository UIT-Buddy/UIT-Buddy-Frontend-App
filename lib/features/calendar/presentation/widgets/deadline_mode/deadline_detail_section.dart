import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:uit_buddy_mobile/core/theme/app_color.dart';
import 'package:uit_buddy_mobile/core/theme/app_text_style.dart';
import 'package:uit_buddy_mobile/features/calendar/domain/entities/calendar_deadline_entity.dart';
import 'package:uit_buddy_mobile/features/calendar/presentation/constants/calendar_text.dart';
import 'package:uit_buddy_mobile/features/calendar/presentation/widgets/deadline_mode/add_deadline_modal.dart';
import 'package:uit_buddy_mobile/features/calendar/presentation/widgets/deadline_mode/deadline_detail_item.dart';

class DeadlineDetailSection extends StatelessWidget {
  const DeadlineDetailSection({
    super.key,
    required this.deadlineDetails,
    this.selectedDay,
    this.month,
    this.year,
  });

  final List<DeadlineDetailEntity> deadlineDetails;
  final int? selectedDay;
  final int? month;
  final int? year;

  String _dateLabel() {
    if (selectedDay == null || month == null || year == null) return 'Tasks';
    final date = DateTime(year!, month!, selectedDay!);
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final tomorrow = today.add(const Duration(days: 1));
    final yesterday = today.subtract(const Duration(days: 1));
    if (date == today) return 'Today';
    if (date == tomorrow) return 'Tomorrow';
    if (date == yesterday) return 'Yesterday';
    return DateFormat('MMM d').format(date);
  }

  @override
  Widget build(BuildContext context) {
    final label = _dateLabel();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 4),
        _SectionHeader(
          dateLabel: label,
          count: deadlineDetails.length,
          onAddPressed: () => showAddDeadlineModal(context),
        ),
        const SizedBox(height: 8),
        Expanded(
          child: deadlineDetails.isEmpty
              ? _EmptyState(dateLabel: label)
              : ListView.builder(
                  itemCount: deadlineDetails.length,
                  itemBuilder: (context, index) => DeadlineDetailItem(
                    deadlineDetailEntity: deadlineDetails[index],
                  ),
                ),
        ),
      ],
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({
    required this.dateLabel,
    required this.count,
    this.onAddPressed,
  });

  final String dateLabel;
  final int count;
  final VoidCallback? onAddPressed;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              dateLabel,
              style: AppTextStyle.h3.copyWith(fontWeight: AppTextStyle.bold),
            ),
            if (count > 0)
              Text(
                CalendarText.upcomingDeadlines(count),
                style: AppTextStyle.captionSmall.copyWith(
                  color: AppColor.secondaryText,
                ),
              ),
          ],
        ),
        const Spacer(),
        GestureDetector(
          onTap: onAddPressed,
          child: Container(
            width: 36,
            height: 36,
            decoration: const BoxDecoration(
              color: AppColor.primaryBlue,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.add, color: AppColor.pureWhite, size: 20),
          ),
        ),
      ],
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.dateLabel});

  final String dateLabel;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              color: AppColor.primaryBlue10,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.check_circle_outline_rounded,
              color: AppColor.primaryBlue,
              size: 36,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'All clear!',
            style: AppTextStyle.h4.copyWith(
              fontWeight: AppTextStyle.bold,
              color: AppColor.primaryText,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'No deadlines on $dateLabel.',
            style: AppTextStyle.bodySmall.copyWith(
              color: AppColor.secondaryText,
            ),
          ),
        ],
      ),
    );
  }
}

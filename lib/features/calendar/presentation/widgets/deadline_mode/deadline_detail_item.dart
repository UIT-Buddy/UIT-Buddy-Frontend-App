import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:uit_buddy_mobile/core/theme/app_color.dart';
import 'package:uit_buddy_mobile/core/theme/app_text_style.dart';
import 'package:uit_buddy_mobile/features/calendar/domain/entities/calendar_deadline_entity.dart';

class DeadlineDetailItem extends StatelessWidget {
  const DeadlineDetailItem({super.key, required this.deadlineDetailEntity});

  final DeadlineDetailEntity deadlineDetailEntity;

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
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 3,
            height: 60,
            color: _getStatusColor(deadlineDetailEntity.status),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(deadlineDetailEntity.title, style: AppTextStyle.h3),
                const SizedBox(height: 4),
                SubTitleText(deadlineDetailEntity: deadlineDetailEntity),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class SubTitleText extends StatelessWidget {
  const SubTitleText({super.key, required this.deadlineDetailEntity});
  final DeadlineDetailEntity deadlineDetailEntity;

  String _formatDeadline(DateTime deadline) {
    final dayOfWeek = DateFormat('EEE').format(deadline);
    final time = DateFormat('HH:mm').format(deadline);
    return '$dayOfWeek $time';
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      '${_formatDeadline(deadlineDetailEntity.deadline)} • ${deadlineDetailEntity.courseId}',
      style: AppTextStyle.captionMedium,
    );
  }
}

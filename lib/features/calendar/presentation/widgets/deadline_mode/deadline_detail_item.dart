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

  Color _getStatusBackgroundColor(CalendarDeadlineItemEntityStatus status) {
    switch (status) {
      case CalendarDeadlineItemEntityStatus.done:
        return AppColor.successGreen10;
      case CalendarDeadlineItemEntityStatus.upcoming:
        return AppColor.primaryBlue10;
      case CalendarDeadlineItemEntityStatus.nearDeadline:
      case CalendarDeadlineItemEntityStatus.overdue:
        return AppColor.alertRed10;
      case CalendarDeadlineItemEntityStatus.empty:
        return Colors.transparent;
    }
  }

  @override
  Widget build(BuildContext context) {
    final statusColor = _getStatusColor(deadlineDetailEntity.status);
    final bgColor = _getStatusBackgroundColor(deadlineDetailEntity.status);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 6),
      child: Container(
        decoration: BoxDecoration(
          color: AppColor.pureWhite,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: statusColor.withValues(alpha: 0.12),
              blurRadius: 10,
              spreadRadius: 0,
              offset: const Offset(0, 3),
            ),
            BoxShadow(
              color: AppColor.shadowColor,
              blurRadius: 4,
              spreadRadius: 0,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Colored accent bar
              Container(
                width: 5,
                decoration: BoxDecoration(
                  color: statusColor,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(14),
                    bottomLeft: Radius.circular(14),
                  ),
                ),
              ),
              // Content
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 12,
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Tinted icon background
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: bgColor,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(
                          Icons.assignment_outlined,
                          color: statusColor,
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 12),
                      // Texts
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              deadlineDetailEntity.title,
                              style: AppTextStyle.bodySmall.copyWith(
                                fontWeight: FontWeight.w600,
                                color: AppColor.primaryText,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 4),
                            SubTitleText(
                              deadlineDetailEntity: deadlineDetailEntity,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
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

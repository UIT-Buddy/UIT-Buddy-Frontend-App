import 'package:flutter/material.dart';
import 'package:uit_buddy_mobile/core/theme/app_color.dart';
import 'package:uit_buddy_mobile/core/theme/app_text_style.dart';
import 'package:uit_buddy_mobile/features/calendar/presentation/constants/calendar_text.dart';

class DeadlineHeader extends StatelessWidget {
  const DeadlineHeader({
    super.key,
    required this.month,
    required this.year,
    this.onPreviousMonth,
    this.onNextMonth,
  });

  final int month;
  final int year;
  final VoidCallback? onPreviousMonth;
  final VoidCallback? onNextMonth;

  String _getMonthName(int month) => CalendarText.monthNames[month - 1];

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              _getMonthName(month),
              style: AppTextStyle.h3.copyWith(
                fontWeight: AppTextStyle.bold,
                color: AppColor.pureWhite,
              ),
            ),
            Text(
              '$year',
              style: AppTextStyle.captionMedium.copyWith(
                color: AppColor.pureWhite.withValues(alpha: 0.75),
              ),
            ),
          ],
        ),
        const Spacer(),
        _NavArrow(icon: Icons.chevron_left, onTap: onPreviousMonth),
        const SizedBox(width: 8),
        _NavArrow(icon: Icons.chevron_right, onTap: onNextMonth),
      ],
    );
  }
}

class _NavArrow extends StatelessWidget {
  const _NavArrow({required this.icon, this.onTap});
  final IconData icon;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.20),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: AppColor.pureWhite, size: 20),
      ),
    );
  }
}

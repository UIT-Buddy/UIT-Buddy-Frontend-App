import 'package:flutter/material.dart';
import 'package:uit_buddy_mobile/core/theme/app_color.dart';
import 'package:uit_buddy_mobile/core/theme/app_text_style.dart';

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

  String _getMonthName(int month) {
    const months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];
    return months[month - 1];
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          '${_getMonthName(month)} $year',
          style: AppTextStyle.bodyLarge.copyWith(fontWeight: AppTextStyle.bold),
        ),
        const Spacer(),
        Container(
          decoration: const BoxDecoration(
            color: AppColor.veryLightGrey,
            shape: BoxShape.circle,
          ),
          child: IconButton(
            onPressed: onPreviousMonth,
            icon: const Icon(Icons.chevron_left),
          ),
        ),
        const SizedBox(width: 8),
        Container(
          decoration: const BoxDecoration(
            color: AppColor.veryLightGrey,
            shape: BoxShape.circle,
          ),
          child: IconButton(
            onPressed: onNextMonth,
            icon: const Icon(Icons.chevron_right),
          ),
        ),
      ],
    );
  }
}

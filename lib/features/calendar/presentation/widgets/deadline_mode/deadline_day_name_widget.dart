import 'package:flutter/material.dart';
import 'package:uit_buddy_mobile/core/theme/app_color.dart';
import 'package:uit_buddy_mobile/core/theme/app_text_style.dart';
import 'package:uit_buddy_mobile/features/calendar/presentation/constants/calendar_text.dart';

class DeadlineDayNameWidget extends StatelessWidget {
  const DeadlineDayNameWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final textStyle = AppTextStyle.captionMedium.copyWith(
      fontWeight: AppTextStyle.medium,
    );

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: CalendarText.dayAbbreviations.asMap().entries.map((e) {
        final isSunday = e.key == 0;
        return Text(
          e.value,
          style: textStyle.copyWith(
            color: isSunday
                ? AppColor.alertRed.withValues(alpha: 0.65)
                : AppColor.secondaryText,
          ),
        );
      }).toList(),
    );
  }
}

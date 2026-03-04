import 'package:flutter/material.dart';
import 'package:uit_buddy_mobile/core/theme/app_text_style.dart';

class DeadlineDayNameWidget extends StatelessWidget {
  const DeadlineDayNameWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final textStyle = AppTextStyle.captionMedium.copyWith(
      fontWeight: AppTextStyle.medium,
    );

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Text('S', style: textStyle),
        Text('M', style: textStyle),
        Text('T', style: textStyle),
        Text('W', style: textStyle),
        Text('T', style: textStyle),
        Text('F', style: textStyle),
        Text('S', style: textStyle),
      ],
    );
  }
}

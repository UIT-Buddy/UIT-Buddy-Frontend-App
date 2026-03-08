import 'package:flutter/material.dart';
import 'package:uit_buddy_mobile/core/theme/app_color.dart';
import 'package:uit_buddy_mobile/core/theme/app_text_style.dart';
import 'package:uit_buddy_mobile/features/calendar/presentation/constants/calendar_text.dart';

/// Displayed when the courses bloc emits an error state.
class CoursesErrorView extends StatelessWidget {
  const CoursesErrorView({super.key, this.message});

  final String? message;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.error_outline, color: AppColor.alertRed, size: 32),
          const SizedBox(height: 8),
          Text(
            CalendarText.coursesErrorPrefix,
            style: AppTextStyle.bodySmall.copyWith(
              color: AppColor.alertRed,
              fontWeight: AppTextStyle.medium,
            ),
          ),
          if (message != null)
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Text(
                message!,
                style: AppTextStyle.captionMedium,
                textAlign: TextAlign.center,
              ),
            ),
        ],
      ),
    );
  }
}

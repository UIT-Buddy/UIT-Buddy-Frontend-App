import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uit_buddy_mobile/core/theme/app_color.dart';
import 'package:uit_buddy_mobile/core/theme/app_text_style.dart';
import 'package:uit_buddy_mobile/features/calendar/presentation/bloc/courses_mode/courses_mode_bloc.dart';
import 'package:uit_buddy_mobile/features/calendar/presentation/bloc/courses_mode/courses_mode_event.dart';
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
          Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              color: AppColor.alertRed.withValues(alpha: 0.10),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.error_outline_rounded,
              color: AppColor.alertRed,
              size: 36,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            CalendarText.coursesErrorPrefix,
            style: AppTextStyle.bodyMedium.copyWith(
              color: AppColor.alertRed,
              fontWeight: AppTextStyle.bold,
            ),
          ),
          if (message != null)
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Text(
                message!,
                style: AppTextStyle.captionMedium.copyWith(
                  color: AppColor.secondaryText,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          const SizedBox(height: 16),
          GestureDetector(
            onTap: () =>
                context.read<CoursesModeBloc>().add(const CoursesModeStarted()),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: AppColor.primaryBlue.withValues(alpha: 0.10),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: AppColor.primaryBlue.withValues(alpha: 0.30),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.refresh_rounded,
                    size: 16,
                    color: AppColor.primaryBlue,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    CalendarText.coursesRetry,
                    style: AppTextStyle.captionMedium.copyWith(
                      color: AppColor.primaryBlue,
                      fontWeight: AppTextStyle.medium,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

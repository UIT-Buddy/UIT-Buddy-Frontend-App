import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uit_buddy_mobile/core/theme/app_color.dart';
import 'package:uit_buddy_mobile/core/theme/app_text_style.dart';
import 'package:uit_buddy_mobile/features/calendar/presentation/bloc/courses_mode/courses_mode_bloc.dart';
import 'package:uit_buddy_mobile/features/calendar/presentation/bloc/courses_mode/courses_mode_event.dart';
import 'package:uit_buddy_mobile/features/calendar/presentation/constants/calendar_text.dart';

/// Displayed when the courses bloc emits an error state.
class CoursesErrorView extends StatelessWidget {
  const CoursesErrorView({super.key, this.message, this.semester, this.year});

  final String? message;
  final int? semester;
  final int? year;

  @override
  Widget build(BuildContext context) {
    if (message != null &&
        (message!.contains('SCH009') ||
            message!.contains('have not uploaded'))) {
      return _buildFriendlyUploadPrompt(context);
    }

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

  Widget _buildFriendlyUploadPrompt(BuildContext context) {
    final fallBackSemester = semester ?? 2;
    final fallBackYear = year ?? 2026;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppColor.primaryBlue.withValues(alpha: 0.10),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.calendar_month_rounded,
              color: AppColor.primaryBlue,
              size: 40,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Missing Schedule',
            style: AppTextStyle.bodyLarge.copyWith(
              color: AppColor.primaryText,
              fontWeight: AppTextStyle.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Your schedule for Semester $fallBackSemester, $fallBackYear hasn\'t been uploaded yet. Please obtain your .ics file from the university portal and upload it here.',
            style: AppTextStyle.bodyMedium.copyWith(
              color: AppColor.secondaryText,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          // We can put a small helper or just rely on the main upload button
          Text(
            'Tap the \'Update Courses\' button above to upload.',
            style: AppTextStyle.captionMedium.copyWith(
              color: AppColor.primaryBlue,
              fontWeight: AppTextStyle.regular,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

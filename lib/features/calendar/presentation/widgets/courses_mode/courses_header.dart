import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uit_buddy_mobile/core/theme/app_color.dart';
import 'package:uit_buddy_mobile/core/theme/app_text_style.dart';
import 'package:uit_buddy_mobile/features/calendar/presentation/bloc/courses_mode/courses_mode_bloc.dart';
import 'package:uit_buddy_mobile/features/calendar/presentation/bloc/courses_mode/courses_mode_event.dart';
import 'package:uit_buddy_mobile/features/calendar/presentation/constants/calendar_text.dart';

/// Displays the semester/year label and previous/next navigation buttons.
class CoursesHeader extends StatelessWidget {
  const CoursesHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<CoursesModeBloc>();
    final state = context.watch<CoursesModeBloc>().state;

    return Row(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              CalendarText.semesterLabel(state.semester, state.year),
              style: AppTextStyle.bodyLarge.copyWith(
                fontWeight: AppTextStyle.bold,
                color: AppColor.pureWhite,
              ),
            ),
            Text(
              'Timetable',
              style: AppTextStyle.captionSmall.copyWith(
                color: AppColor.pureWhite.withValues(alpha: 0.75),
              ),
            ),
          ],
        ),
        const Spacer(),
        _CoursesNavButton(
          icon: Icons.chevron_left,
          onTap: () => bloc.add(const CoursesModePreviousSemester()),
        ),
        const SizedBox(width: 8),
        _CoursesNavButton(
          icon: Icons.chevron_right,
          onTap: () => bloc.add(const CoursesModeNextSemester()),
        ),
      ],
    );
  }
}

class _CoursesNavButton extends StatelessWidget {
  const _CoursesNavButton({required this.icon, required this.onTap});

  final IconData icon;
  final VoidCallback onTap;

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

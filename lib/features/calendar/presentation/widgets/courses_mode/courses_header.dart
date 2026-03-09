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
        Text(
          CalendarText.semesterLabel(state.semester, state.year),
          style: AppTextStyle.bodyLarge.copyWith(fontWeight: AppTextStyle.bold),
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
    return Container(
      decoration: const BoxDecoration(
        color: AppColor.veryLightGrey,
        shape: BoxShape.circle,
      ),
      child: IconButton(
        onPressed: onTap,
        icon: Icon(icon),
        padding: const EdgeInsets.all(6),
        constraints: const BoxConstraints(),
        iconSize: 20,
      ),
    );
  }
}

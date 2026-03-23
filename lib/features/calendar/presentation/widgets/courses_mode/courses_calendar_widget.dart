import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uit_buddy_mobile/core/theme/app_color.dart';
import 'package:uit_buddy_mobile/features/calendar/presentation/bloc/courses_mode/courses_mode_bloc.dart';
import 'package:uit_buddy_mobile/features/calendar/presentation/bloc/courses_mode/courses_mode_state.dart';
import 'package:uit_buddy_mobile/features/calendar/presentation/widgets/courses_mode/courses_error_view.dart';
import 'package:uit_buddy_mobile/features/calendar/presentation/widgets/courses_mode/courses_header.dart';
import 'package:uit_buddy_mobile/features/calendar/presentation/widgets/courses_mode/courses_timetable_grid.dart';

// ── Main widget ────────────────────────────────────────────────────────────
class CoursesCalendarWidget extends StatelessWidget {
  const CoursesCalendarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CoursesModeBloc, CoursesModeState>(
      builder: (context, state) {
        final screenWidth = MediaQuery.of(context).size.width;
        final hPad = screenWidth * 0.045;
        final radius = screenWidth * 0.065;

        return SingleChildScrollView(
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 6),
            decoration: BoxDecoration(
              color: AppColor.pureWhite,
              borderRadius: BorderRadius.circular(radius),
              boxShadow: [
                BoxShadow(
                  color: AppColor.primaryBlue.withValues(alpha: 0.10),
                  blurRadius: 20,
                  offset: const Offset(0, 6),
                ),
                BoxShadow(
                  color: AppColor.shadowColor,
                  blurRadius: 4,
                  offset: const Offset(0, 1),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Gradient header strip
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: hPad,
                    vertical: hPad * 0.75,
                  ),
                  decoration: BoxDecoration(
                    gradient: AppColor.primaryGradient,
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(radius),
                    ),
                  ),
                  child: const CoursesHeader(),
                ),
                // Grid / loading / error
                Padding(
                  padding: EdgeInsets.all(hPad),
                  child: state.status == CoursesModeStatus.loading
                      ? const Padding(
                          padding: EdgeInsets.symmetric(vertical: 40),
                          child: Center(child: CircularProgressIndicator()),
                        )
                      : state.status == CoursesModeStatus.error
                      ? CoursesErrorView(message: state.errorMessage)
                      : CoursesTimetableGrid(courses: state.courses),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

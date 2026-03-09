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
        final spacing = screenWidth * 0.05;

        return SingleChildScrollView(
          child: Container(
            margin: EdgeInsets.all(spacing),
            padding: EdgeInsets.all(spacing),
            decoration: BoxDecoration(
              color: AppColor.pureWhite,
              border: Border.all(color: AppColor.dividerGrey, width: 1),
              borderRadius: BorderRadius.circular(screenWidth * 0.065),
              boxShadow: [
                BoxShadow(
                  color: AppColor.shadowColor,
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const CoursesHeader(),
                SizedBox(height: screenWidth * 0.04),
                if (state.status == CoursesModeStatus.loading)
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 40),
                    child: Center(child: CircularProgressIndicator()),
                  )
                else if (state.status == CoursesModeStatus.error)
                  CoursesErrorView(message: state.errorMessage)
                else
                  CoursesTimetableGrid(courses: state.courses),
              ],
            ),
          ),
        );
      },
    );
  }
}

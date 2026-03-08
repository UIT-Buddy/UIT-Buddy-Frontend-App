import 'package:flutter/material.dart';
import 'package:uit_buddy_mobile/core/theme/app_color.dart';
import 'package:uit_buddy_mobile/features/calendar/domain/entities/course_details_entity.dart';
import 'package:uit_buddy_mobile/features/calendar/presentation/widgets/courses_mode/course_block.dart';
import 'package:uit_buddy_mobile/features/calendar/presentation/widgets/courses_mode/course_details_bottom_sheet.dart';
import 'package:uit_buddy_mobile/features/calendar/presentation/widgets/courses_mode/courses_timetable_constants.dart';

/// Renders a single day column: grid lines for all 10 periods + course blocks
/// stacked on top via a [Stack].
class CoursesDayColumn extends StatelessWidget {
  const CoursesDayColumn({
    super.key,
    required this.dayCourses,
    required this.colorMap,
    required this.isLast,
  });

  final List<CourseDetailsEntity> dayCourses;

  /// Maps courseId → palette index.
  final Map<String, int> colorMap;

  final bool isLast;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: kCourseTotalPeriods * kCourseRowHeight,
      child: Stack(
        children: [
          // ── Background grid lines ─────────────────────────────────────
          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(
                border: Border(
                  left: BorderSide(color: AppColor.dividerGrey, width: 0.5),
                ),
              ),
              child: Column(
                children: List.generate(kCourseTotalPeriods, (i) {
                  return Container(
                    height: kCourseRowHeight,
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: i < kCourseTotalPeriods - 1
                            ? const BorderSide(
                                color: AppColor.dividerGrey,
                                width: 0.5,
                              )
                            : BorderSide.none,
                      ),
                    ),
                  );
                }),
              ),
            ),
          ),

          // ── Course blocks ────────────────────────────────────────────
          ...dayCourses.map((course) {
            final paletteIdx = colorMap[course.courseId] ?? 0;
            final (bgColor, fgColor) = kCoursePalette[paletteIdx];
            return Positioned(
              top: (course.startPeriod - 1) * kCourseRowHeight,
              left: 2,
              right: 2,
              height:
                  (course.endPeriod - course.startPeriod + 1) *
                  kCourseRowHeight,
              child: GestureDetector(
                onTap: () => showCourseDetailsBottomSheet(context, course),
                child: CourseBlock(
                  course: course,
                  bgColor: bgColor,
                  fgColor: fgColor,
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}

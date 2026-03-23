import 'package:flutter/material.dart';
import 'package:uit_buddy_mobile/core/theme/app_color.dart';
import 'package:uit_buddy_mobile/core/theme/app_text_style.dart';
import 'package:uit_buddy_mobile/features/calendar/domain/entities/course_details_entity.dart';
import 'package:uit_buddy_mobile/features/calendar/presentation/constants/calendar_text.dart';
import 'package:uit_buddy_mobile/features/calendar/presentation/widgets/courses_mode/course_block.dart';
import 'package:uit_buddy_mobile/features/calendar/presentation/widgets/courses_mode/course_details_bottom_sheet.dart';
import 'package:uit_buddy_mobile/features/calendar/presentation/widgets/courses_mode/courses_day_column.dart';
import 'package:uit_buddy_mobile/features/calendar/presentation/widgets/courses_mode/courses_timetable_constants.dart';

/// The main timetable grid: day-header row + period-label column + day columns
/// + an optional Blended-Learning (BL) row at the bottom.
class CoursesTimetableGrid extends StatelessWidget {
  const CoursesTimetableGrid({super.key, required this.courses});

  final List<CourseDetailsEntity> courses;

  /// Assigns a stable palette index per unique [courseId].
  ///
  /// Because both a main class (e.g. "SE347.Q14") and its lab section
  /// ("SE347.Q14.1") share the same [courseId] ("SE347"), they naturally
  /// receive the same colour without any special-casing.
  Map<String, int> _buildColorMap() {
    final ids = courses.map((c) => c.courseId).toSet().toList();
    return {
      for (int i = 0; i < ids.length; i++) ids[i]: i % kCoursePalette.length,
    };
  }

  List<CourseDetailsEntity> _regularCoursesForDay(int dayIndex) => courses
      .where(
        (c) =>
            !c.isBlendedLearning &&
            c.dayOfWeek == dayIndex + kCourseDayIndexOffset,
      )
      .toList();

  List<CourseDetailsEntity> _blCoursesForDay(int dayIndex) => courses
      .where(
        (c) =>
            c.isBlendedLearning &&
            c.dayOfWeek == dayIndex + kCourseDayIndexOffset,
      )
      .toList();

  bool get _hasBlCourses => courses.any((c) => c.isBlendedLearning);

  @override
  Widget build(BuildContext context) {
    if (courses.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                color: AppColor.primaryBlue.withValues(alpha: 0.08),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.calendar_today_outlined,
                color: AppColor.primaryBlue,
                size: 36,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              CalendarText.coursesEmptyState,
              style: AppTextStyle.bodyMedium.copyWith(
                fontWeight: AppTextStyle.bold,
                color: AppColor.primaryText,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'No courses scheduled this semester.',
              style: AppTextStyle.captionMedium.copyWith(
                color: AppColor.secondaryText,
              ),
            ),
          ],
        ),
      );
    }

    final colorMap = _buildColorMap();
    final hasBL = _hasBlCourses;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // ── Day-header row ────────────────────────────────────────────────
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // "P" label above the period column
            SizedBox(
              width: kCoursePeriodColWidth,
              height: kCourseHeaderRowHeight,
              child: Center(
                child: Text(
                  CalendarText.periodColumnHeader,
                  style: AppTextStyle.captionSmall.copyWith(
                    fontWeight: AppTextStyle.bold,
                    color: AppColor.primaryText,
                  ),
                ),
              ),
            ),
            // Day name cells
            ...List.generate(kCourseTotalDays, (i) {
              return Expanded(
                child: Container(
                  height: kCourseHeaderRowHeight,
                  decoration: BoxDecoration(
                    color: AppColor.veryLightGrey,
                    borderRadius: i == 0
                        ? const BorderRadius.only(
                            topLeft: Radius.circular(6),
                            bottomLeft: Radius.circular(6),
                          )
                        : i == kCourseTotalDays - 1
                        ? const BorderRadius.only(
                            topRight: Radius.circular(6),
                            bottomRight: Radius.circular(6),
                          )
                        : BorderRadius.zero,
                  ),
                  child: Center(
                    child: Text(
                      CalendarText.timetableDayHeaders[i],
                      style: AppTextStyle.captionSmall.copyWith(
                        fontWeight: AppTextStyle.bold,
                        color: AppColor.primaryText,
                      ),
                    ),
                  ),
                ),
              );
            }),
          ],
        ),
        const SizedBox(height: 4),

        // ── Period rows + day columns ─────────────────────────────────────
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Period label column (1–10)
            Column(
              children: List.generate(kCourseTotalPeriods, (i) {
                return Container(
                  width: kCoursePeriodColWidth,
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
                  child: Center(
                    child: Text(
                      '${i + 1}',
                      style: AppTextStyle.captionSmall.copyWith(
                        fontWeight: AppTextStyle.medium,
                        color: AppColor.secondaryText,
                      ),
                    ),
                  ),
                );
              }),
            ),
            // One column per day
            ...List.generate(kCourseTotalDays, (dayIdx) {
              return Expanded(
                child: CoursesDayColumn(
                  dayCourses: _regularCoursesForDay(dayIdx),
                  colorMap: colorMap,
                  isLast: dayIdx == kCourseTotalDays - 1,
                ),
              );
            }),
          ],
        ),

        // ── Blended-Learning row (only rendered when BL courses exist) ────
        if (hasBL) ...[
          Container(height: 1, color: AppColor.dividerGrey),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // "BL" label cell
              Container(
                width: kCoursePeriodColWidth,
                height: kCourseBLRowHeight,
                alignment: Alignment.center,
                child: Text(
                  CalendarText.blendedLearningRowLabel,
                  style: AppTextStyle.captionSmall.copyWith(
                    fontWeight: AppTextStyle.bold,
                    color: AppColor.secondaryText,
                  ),
                ),
              ),
              // BL day cells
              ...List.generate(kCourseTotalDays, (dayIdx) {
                return Expanded(
                  child: _CoursesBlDayCell(
                    blCourses: _blCoursesForDay(dayIdx),
                    colorMap: colorMap,
                    isLast: dayIdx == kCourseTotalDays - 1,
                  ),
                );
              }),
            ],
          ),
        ],
      ],
    );
  }
}

// ── BL row day cell ───────────────────────────────────────────────────────────
/// One cell in the Blended-Learning row for a single day column.
/// Stacks up to N BL course blocks side-by-side inside the fixed-height cell.
class _CoursesBlDayCell extends StatelessWidget {
  const _CoursesBlDayCell({
    required this.blCourses,
    required this.colorMap,
    required this.isLast,
  });

  final List<CourseDetailsEntity> blCourses;
  final Map<String, int> colorMap;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: kCourseBLRowHeight,
      decoration: const BoxDecoration(
        border: Border(
          left: BorderSide(color: AppColor.dividerGrey, width: 0.5),
        ),
      ),
      padding: const EdgeInsets.all(2),
      child: blCourses.isEmpty
          ? const SizedBox.shrink()
          : Row(
              children: blCourses.map((course) {
                final paletteIdx = colorMap[course.courseId] ?? 0;
                final (bgColor, fgColor) = kCoursePalette[paletteIdx];
                return Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 1),
                    child: GestureDetector(
                      onTap: () =>
                          showCourseDetailsBottomSheet(context, course),
                      child: CourseBlock(
                        course: course,
                        bgColor: bgColor,
                        fgColor: fgColor,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
    );
  }
}

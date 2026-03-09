import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:uit_buddy_mobile/core/theme/app_color.dart';
import 'package:uit_buddy_mobile/core/theme/app_text_style.dart';
import 'package:uit_buddy_mobile/features/calendar/domain/entities/course_details_entity.dart';
import 'package:uit_buddy_mobile/features/calendar/presentation/constants/calendar_text.dart';

/// Opens a read-only bottom sheet with the full details of [course].
void showCourseDetailsBottomSheet(
  BuildContext context,
  CourseDetailsEntity course,
) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    backgroundColor: Colors.transparent,
    builder: (_) => _CourseDetailsSheet(course: course),
  );
}

// ─────────────────────────────────────────────────────────────────────────────
// Sheet
// ─────────────────────────────────────────────────────────────────────────────

class _CourseDetailsSheet extends StatelessWidget {
  const _CourseDetailsSheet({required this.course});

  final CourseDetailsEntity course;

  String _dayName(int dayOfWeek) => switch (dayOfWeek) {
    2 => 'Monday',
    3 => 'Tuesday',
    4 => 'Wednesday',
    5 => 'Thursday',
    6 => 'Friday',
    7 => 'Saturday',
    _ => '—',
  };

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColor.pureWhite,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Drag handle ─────────────────────────────────────────────
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColor.dividerGrey,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // ── Header ──────────────────────────────────────────────────
            Row(
              children: [
                Text(
                  CalendarText.courseDetailsTitle,
                  style: AppTextStyle.h3.copyWith(
                    fontWeight: AppTextStyle.bold,
                  ),
                ),
                const Spacer(),
                GestureDetector(
                  onTap: () => Navigator.of(context).pop(),
                  child: Container(
                    width: 32,
                    height: 32,
                    decoration: const BoxDecoration(
                      color: AppColor.veryLightGrey,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.close,
                      size: 18,
                      color: AppColor.secondaryText,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // ── CLASS ID ────────────────────────────────────────────────
            _LabeledField(
              label: CalendarText.courseDetailsFieldClassId,
              value: course.classId,
              icon: Icons.badge_outlined,
            ),
            const SizedBox(height: 16),

            // ── COURSE NAME ─────────────────────────────────────────────
            _LabeledField(
              label: CalendarText.courseDetailsFieldCourseName,
              value: course.courseName,
              icon: Icons.book_outlined,
            ),
            const SizedBox(height: 16),

            // ── CREDITS ─────────────────────────────────────────────────
            _LabeledField(
              label: CalendarText.courseDetailsFieldCredits,
              value: course.credits.toString(),
              icon: Icons.stars_outlined,
            ),
            const SizedBox(height: 16),

            // ── LECTURER ────────────────────────────────────────────────
            _LabeledField(
              label: CalendarText.courseDetailsFieldLecturer,
              value: course.lecturer,
              icon: Icons.person_outlined,
            ),
            const SizedBox(height: 16),

            // ── ROOM ────────────────────────────────────────────────────
            _LabeledField(
              label: CalendarText.courseDetailsFieldRoom,
              value: course.room,
              icon: Icons.location_on_outlined,
            ),
            const SizedBox(height: 16),

            // ── DAY OF WEEK ─────────────────────────────────────────────
            _LabeledField(
              label: CalendarText.courseDetailsFieldDayOfWeek,
              value: _dayName(course.dayOfWeek),
              icon: Icons.calendar_today_outlined,
            ),
            const SizedBox(height: 16),

            // ── START TIME / END TIME ────────────────────────────────────
            if (!course.isBlendedLearning) ...[
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: _LabeledField(
                      label: CalendarText.courseDetailsFieldStartTime,
                      value: course.startTime.isNotEmpty
                          ? course.startTime
                          : '—',
                      icon: Icons.schedule,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _LabeledField(
                      label: CalendarText.courseDetailsFieldEndTime,
                      value: course.endTime.isNotEmpty ? course.endTime : '—',
                      icon: Icons.schedule_outlined,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
            ] else
              const SizedBox(height: 8),

            // ── TASKS ────────────────────────────────────────────────────
            const Divider(height: 1),
            const SizedBox(height: 20),
            Text(
              CalendarText.courseDetailsTasksSection,
              style: AppTextStyle.captionLarge.copyWith(
                fontWeight: FontWeight.w600,
                letterSpacing: 0.8,
                color: AppColor.secondaryText,
              ),
            ),
            const SizedBox(height: 12),

            if (course.deadlines.isEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Text(
                  CalendarText.courseDetailsNoTasks,
                  style: AppTextStyle.captionLarge.copyWith(
                    color: AppColor.tertiaryText,
                  ),
                ),
              )
            else
              ...course.deadlines.map((d) => _TaskItem(deadline: d)),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Read-only labelled field
// ─────────────────────────────────────────────────────────────────────────────

class _LabeledField extends StatelessWidget {
  const _LabeledField({required this.label, required this.value, this.icon});

  final String label;
  final String value;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyle.captionLarge.copyWith(
            fontWeight: FontWeight.w600,
            letterSpacing: 0.8,
            color: AppColor.secondaryText,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 14),
          decoration: BoxDecoration(
            color: AppColor.veryLightGrey,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            children: [
              if (icon != null) ...[
                Icon(icon, size: 18, color: AppColor.secondaryText),
                const SizedBox(width: 10),
              ],
              Expanded(child: Text(value, style: AppTextStyle.bodyMedium)),
            ],
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Task / deadline item
// ─────────────────────────────────────────────────────────────────────────────

class _TaskItem extends StatelessWidget {
  const _TaskItem({required this.deadline});

  final DeadlineDetailEntity deadline;

  (IconData, Color) _statusStyle() => switch (deadline.status) {
    TaskEntityStatus.done => (
      Icons.check_circle_outline,
      AppColor.successGreen,
    ),
    TaskEntityStatus.nearDeadline => (
      Icons.warning_amber_outlined,
      AppColor.warningOrange,
    ),
    TaskEntityStatus.overdue => (Icons.error_outline, AppColor.alertRed),
    _ => (Icons.schedule, AppColor.primaryBlue),
  };

  @override
  Widget build(BuildContext context) {
    final (icon, color) = _statusStyle();
    final dateStr = DateFormat(
      CalendarText.dateFormatDisplay,
    ).format(deadline.deadline);

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.12),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 17),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  deadline.title,
                  style: AppTextStyle.bodySmall.copyWith(
                    fontWeight: FontWeight.w500,
                    color: AppColor.primaryText,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 3),
                Text(dateStr, style: AppTextStyle.captionMedium),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

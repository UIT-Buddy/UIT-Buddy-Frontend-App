import 'package:flutter/material.dart';
import 'package:uit_buddy_mobile/features/calendar/domain/entities/course_details_entity.dart';

/// A coloured card that represents a single course in the timetable.
///
/// Shows:
/// - [classId] always
/// - [room] if the course spans ≥ 2 periods
class CourseBlock extends StatelessWidget {
  const CourseBlock({
    super.key,
    required this.course,
    required this.bgColor,
    required this.fgColor,
    this.onTap,
  });

  final CourseDetailsEntity course;
  final Color bgColor;
  final Color fgColor;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final spanPeriods = course.endPeriod - course.startPeriod + 1;
    final isCompact = spanPeriods < 2;

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(5),
          border: Border.all(color: fgColor.withValues(alpha: 0.4), width: 1),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 3, vertical: 2),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Class ID (e.g. "SE347.Q14")
            Text(
              course.classId,
              style: TextStyle(
                fontSize: 9,
                fontWeight: FontWeight.w700,
                color: fgColor,
                height: 1.2,
              ),
              maxLines: isCompact ? 1 : 2,
              overflow: TextOverflow.ellipsis,
            ),
            // Room — visible when ≥ 2 periods
            if (!isCompact) ...[
              const SizedBox(height: 1),
              Text(
                course.room,
                style: TextStyle(
                  fontSize: 8,
                  fontWeight: FontWeight.w400,
                  color: fgColor.withValues(alpha: 0.8),
                  height: 1.2,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

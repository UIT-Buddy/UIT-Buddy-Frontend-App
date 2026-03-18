import 'package:flutter/material.dart';
import 'package:uit_buddy_mobile/core/theme/app_color.dart';
import 'package:uit_buddy_mobile/core/theme/app_text_style.dart';
import 'package:uit_buddy_mobile/features/calendar/domain/entities/calendar_deadline_entity.dart';
import 'package:uit_buddy_mobile/features/calendar/presentation/widgets/deadline_mode/deadline_detail_item.dart';
import 'package:uit_buddy_mobile/features/home/presentation/constants/home_text.dart';

final _sampleDeadlines = [
  DeadlineDetailEntity(
    id: '1',
    title: 'Bài tập lớn — Nhập môn lập trình',
    status: CalendarDeadlineItemEntityStatus.nearDeadline,
    courseId: 'SE100.Q21',
    deadline: DateTime(2026, 3, 20, 23, 59),
  ),
  DeadlineDetailEntity(
    id: '2',
    title: 'Báo cáo thực hành Lab',
    status: CalendarDeadlineItemEntityStatus.upcoming,
    courseId: 'CS201.Q11',
    deadline: DateTime(2026, 3, 25, 17, 0),
  ),
  DeadlineDetailEntity(
    id: '3',
    title: 'Tiểu luận cuối kỳ',
    status: CalendarDeadlineItemEntityStatus.overdue,
    courseId: 'IT001.Q12',
    deadline: DateTime(2026, 3, 15, 23, 59),
  ),
];

class HomeDeadlineWidget extends StatelessWidget {
  const HomeDeadlineWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _DeadlineSectionHeader(count: _sampleDeadlines.length),
        const SizedBox(height: 8),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: _sampleDeadlines.length,
          itemBuilder: (context, index) =>
              DeadlineDetailItem(deadlineDetailEntity: _sampleDeadlines[index]),
        ),
      ],
    );
  }
}

class _DeadlineSectionHeader extends StatelessWidget {
  const _DeadlineSectionHeader({required this.count});

  final int count;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              HomeText.deadlineSectionTitle,
              style: AppTextStyle.h3.copyWith(fontWeight: FontWeight.w700),
            ),
          ],
        ),
        const Spacer(),
        GestureDetector(
          onTap: () {},
          child: Text(
            HomeText.deadlineSeeAll,
            style: AppTextStyle.captionMedium.copyWith(
              color: AppColor.primaryBlue,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }
}

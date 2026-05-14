import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uit_buddy_mobile/core/theme/app_text_style.dart';
import 'package:uit_buddy_mobile/features/calendar/domain/entities/calendar_deadline_entity.dart';
import 'package:uit_buddy_mobile/features/calendar/presentation/widgets/deadline_mode/deadline_detail_item.dart';
import 'package:uit_buddy_mobile/features/home/domain/entities/incoming_deadline_entity.dart';
import 'package:uit_buddy_mobile/features/home/presentation/bloc/home/home_bloc.dart';
import 'package:uit_buddy_mobile/features/home/presentation/bloc/home/home_state.dart';
import 'package:uit_buddy_mobile/features/home/presentation/constants/home_text.dart';
import 'package:go_router/go_router.dart';
import 'package:uit_buddy_mobile/app/router/route_name.dart';

class HomeDeadlineWidget extends StatelessWidget {
  const HomeDeadlineWidget({super.key});

  CalendarDeadlineItemEntityStatus _determineStatus(
    IncomingDeadlineEntity entity,
  ) {
    if (entity.dueDate.isBefore(DateTime.now())) {
      return CalendarDeadlineItemEntityStatus.overdue;
    }

    // If due in hours or minutes, or 1 day, it's near deadline
    if (entity.remainingTime.unitName == TimeUnit.minute ||
        entity.remainingTime.unitName == TimeUnit.hour ||
        (entity.remainingTime.unitName == TimeUnit.day &&
            entity.remainingTime.unit <= 1)) {
      return CalendarDeadlineItemEntityStatus.nearDeadline;
    }

    return CalendarDeadlineItemEntityStatus.upcoming;
  }

  String _formatRemainingTime(RemainingTimeEntity time) {
    final unitStr = time.unitName.name;
    final plural = time.unit > 1 ? 's' : '';
    return 'Due in ${time.unit} $unitStr$plural';
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeBloc, HomeState>(
      builder: (context, state) {
        if (state.status == HomeStatus.loading ||
            state.status == HomeStatus.initial) {
          return const Center(child: CircularProgressIndicator());
        }
        final deadlines = state.homepageData?.incomingDeadlines ?? [];

        if (deadlines.isEmpty) {
          return const SizedBox.shrink(); // Or some empty state
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _DeadlineSectionHeader(count: deadlines.length),
            const SizedBox(height: 8),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: deadlines.length,
              itemBuilder: (context, index) {
                final deadline = deadlines[index];

                final status = _determineStatus(deadline);
                String courseText = _formatRemainingTime(
                  deadline.remainingTime,
                );
                if (status == CalendarDeadlineItemEntityStatus.overdue) {
                  courseText = 'Overdue';
                }

                final detailEntity = DeadlineDetailEntity(
                  id: deadline.id,
                  title: deadline.deadlineName,
                  status: status,
                  courseId: courseText,
                  deadline: deadline.dueDate,
                );

                return GestureDetector(
                  onTap: () {
                    context.push(
                      RouteName.deadlineDetail,
                      extra: {'id': deadline.id},
                    );
                  },
                  child: DeadlineDetailItem(deadlineDetailEntity: detailEntity),
                );
              },
            ),
          ],
        );
      },
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
              '${HomeText.deadlineSectionTitle}$count)',
              style: AppTextStyle.h3.copyWith(fontWeight: FontWeight.w700),
            ),
          ],
        ),
        const Spacer(),
        // GestureDetector(
        //   onTap: () {},
        //   child: Text(
        //     HomeText.deadlineSeeAll,
        //     style: AppTextStyle.captionMedium.copyWith(
        //       color: AppColor.primaryBlue,
        //       fontWeight: FontWeight.w500,
        //     ),
        //   ),
        // ),
      ],
    );
  }
}

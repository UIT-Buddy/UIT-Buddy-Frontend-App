import 'package:flutter/material.dart';
import 'package:uit_buddy_mobile/core/theme/app_color.dart';
import 'package:uit_buddy_mobile/core/theme/app_text_style.dart';
import 'package:uit_buddy_mobile/features/calendar/domain/entities/calendar_deadline_entity.dart';
import 'package:uit_buddy_mobile/features/calendar/presentation/widgets/deadline_mode/deadline_detail_item.dart';

class DeadlineDetailSection extends StatelessWidget {
  const DeadlineDetailSection({super.key, required this.deadlineDetails});
  final List<DeadlineDetailEntity> deadlineDetails;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          DeadlineDetailHeaderSection(
            numberOfDeadlines: deadlineDetails.length,
          ),
          const SizedBox(height: 5),
          Expanded(
            child: ListView(
              children: deadlineDetails
                  .map(
                    (detail) =>
                        DeadlineDetailItem(deadlineDetailEntity: detail),
                  )
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }
}

class DeadlineDetailHeaderSection extends StatelessWidget {
  const DeadlineDetailHeaderSection({
    super.key,
    required this.numberOfDeadlines,
    this.onAddPressed,
  });
  final int numberOfDeadlines;
  final VoidCallback? onAddPressed;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          'Upcoming ($numberOfDeadlines)',
          style: AppTextStyle.h3.copyWith(fontWeight: AppTextStyle.bold),
        ),
        const Spacer(),
        Container(
          decoration: const BoxDecoration(
            color: AppColor.primaryBlue,
            shape: BoxShape.circle,
          ),
          child: IconButton(
            onPressed: onAddPressed,
            icon: const Icon(Icons.add),
            color: AppColor.pureWhite,
            iconSize: 20,
          ),
        ),
      ],
    );
  }
}

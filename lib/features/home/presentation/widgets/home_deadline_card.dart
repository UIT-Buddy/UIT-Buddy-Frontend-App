import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:uit_buddy_mobile/core/theme/app_color.dart';
import 'package:uit_buddy_mobile/core/theme/app_text_style.dart';
import 'package:uit_buddy_mobile/features/home/domain/entities/home_deadline_entity.dart';

class HomeDeadlineCard extends StatelessWidget {
  const HomeDeadlineCard({super.key, required this.entity});

  final HomeDeadlineEntity entity;

  Color get _barColor {
    return switch (entity.urgency) {
      HomeDeadlineUrgency.urgent => AppColor.alertRed,
      HomeDeadlineUrgency.warning => AppColor.warningOrange,
      HomeDeadlineUrgency.normal => AppColor.primaryBlue,
    };
  }

  Color get _backgroundColor {
    return switch (entity.urgency) {
      HomeDeadlineUrgency.urgent => AppColor.alertRed10,
      HomeDeadlineUrgency.warning => AppColor.warningOrangeLight,
      HomeDeadlineUrgency.normal => AppColor.primaryBlue10,
    };
  }

  @override
  Widget build(BuildContext context) {
    final timeLabel = DateFormat('EEE HH:mm').format(entity.deadline);

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: _backgroundColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            width: 4,
            height: 64,
            decoration: BoxDecoration(
              color: _barColor,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                bottomLeft: Radius.circular(12),
              ),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    entity.title,
                    style: AppTextStyle.bodySmall.copyWith(
                      fontWeight: AppTextStyle.medium,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '$timeLabel • ${entity.timeLeftLabel}',
                    style: AppTextStyle.captionMedium,
                  ),
                ],
              ),
            ),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.more_horiz,
              color: AppColor.secondaryText,
              size: 20,
            ),
          ),
        ],
      ),
    );
  }
}

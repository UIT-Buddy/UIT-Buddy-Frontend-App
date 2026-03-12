import 'package:flutter/material.dart';
import 'package:uit_buddy_mobile/core/theme/app_color.dart';
import 'package:uit_buddy_mobile/core/theme/app_text_style.dart';
import 'package:uit_buddy_mobile/features/home/presentation/constants/home_text.dart';

class HomeHeaderWidget extends StatelessWidget {
  const HomeHeaderWidget({
    super.key,
    required this.userName,
    required this.classCountToday,
    this.onNotificationTap,
  });

  final String userName;
  final int classCountToday;
  final VoidCallback? onNotificationTap;

  @override
  Widget build(BuildContext context) {
    final subtitle = classCountToday == 1
        ? 'You got 1 ${HomeText.classThisEvening}'
        : 'You got $classCountToday ${HomeText.classesToday}';

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${HomeText.welcomeBack}\n$userName! 👋',
                style: AppTextStyle.h1.copyWith(
                  fontWeight: AppTextStyle.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: AppTextStyle.bodyMedium.copyWith(
                  color: AppColor.secondaryText,
                ),
              ),
            ],
          ),
        ),
        _NotificationBell(onTap: onNotificationTap),
      ],
    );
  }
}

class _NotificationBell extends StatelessWidget {
  const _NotificationBell({this.onTap});

  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: AppColor.veryLightGrey,
          shape: BoxShape.circle,
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            const Icon(
              Icons.notifications_outlined,
              color: AppColor.primaryText,
              size: 22,
            ),
            Positioned(
              top: 8,
              right: 8,
              child: Container(
                width: 8,
                height: 8,
                decoration: const BoxDecoration(
                  color: AppColor.alertRed,
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

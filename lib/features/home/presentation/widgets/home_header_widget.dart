import 'package:flutter/material.dart';
import 'package:uit_buddy_mobile/app/router/extensions/router_extension.dart';
import 'package:uit_buddy_mobile/app/router/route_name.dart';
import 'package:uit_buddy_mobile/core/theme/app_color.dart';
import 'package:uit_buddy_mobile/core/theme/app_text_style.dart';
import 'package:uit_buddy_mobile/features/home/presentation/constants/home_text.dart';

class HomeHeaderWidget extends StatelessWidget {
  const HomeHeaderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(HomeText.welcomeBack, style: AppTextStyle.h1),
              Text(
                HomeText.userName,
                style: AppTextStyle.h1.copyWith(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 4),
              Text(
                HomeText.classThisEvening,
                style: AppTextStyle.bodySmall.copyWith(
                  color: AppColor.secondaryText,
                ),
              ),
            ],
          ),
        ),
        IconButton(
          onPressed: () => context.goTo(RouteName.notification),
          icon: const Icon(
            Icons.notifications_outlined,
            color: AppColor.primaryText,
            size: 28,
          ),
          style: IconButton.styleFrom(
            backgroundColor: AppColor.veryLightGrey,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
      ],
    );
  }
}

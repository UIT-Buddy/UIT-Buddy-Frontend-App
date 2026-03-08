import 'package:flutter/material.dart';
import 'package:uit_buddy_mobile/core/theme/app_color.dart';
import 'package:uit_buddy_mobile/core/theme/app_text_style.dart';
import 'package:uit_buddy_mobile/features/profile/presentation/constants/profile_text.dart';

class ProfileActionTabsWidget extends StatelessWidget {
  const ProfileActionTabsWidget({
    super.key,
    this.onTasksTap,
    this.onYourInfoTap,
    this.onYourPostsTap,
    this.onGroupsTap,
  });

  final VoidCallback? onTasksTap;
  final VoidCallback? onYourInfoTap;
  final VoidCallback? onYourPostsTap;
  final VoidCallback? onGroupsTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
      decoration: BoxDecoration(
        color: AppColor.pureWhite,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: AppColor.shadowColor,
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _ActionTab(
            icon: Icons.alarm_outlined,
            label: ProfileText.tasks,
            iconColor: AppColor.alertRed,
            bgColor: AppColor.alertRed10,
            onTap: onTasksTap,
          ),
          _ActionTab(
            icon: Icons.badge_outlined,
            label: ProfileText.yourInfo,
            iconColor: AppColor.primaryBlue,
            bgColor: AppColor.primaryBlue10,
            onTap: onYourInfoTap,
          ),
          _ActionTab(
            icon: Icons.people_outline,
            label: ProfileText.yourPosts,
            iconColor: AppColor.warningOrange,
            bgColor: AppColor.warningOrangeLight,
            onTap: onYourPostsTap,
          ),
          _ActionTab(
            icon: Icons.chat_bubble_outline,
            label: ProfileText.groupsJoined,
            iconColor: AppColor.successGreen,
            bgColor: AppColor.successGreen10,
            onTap: onGroupsTap,
          ),
        ],
      ),
    );
  }
}

class _ActionTab extends StatelessWidget {
  const _ActionTab({
    required this.icon,
    required this.label,
    required this.iconColor,
    required this.bgColor,
    this.onTap,
  });

  final IconData icon;
  final String label;
  final Color iconColor;
  final Color bgColor;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(icon, color: iconColor, size: 26),
          ),
          const SizedBox(height: 6),
          Text(
            label,
            textAlign: TextAlign.center,
            style: AppTextStyle.captionSmall.copyWith(
              fontWeight: AppTextStyle.medium,
              color: iconColor,
            ),
          ),
        ],
      ),
    );
  }
}

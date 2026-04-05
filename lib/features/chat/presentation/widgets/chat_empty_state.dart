import 'package:flutter/material.dart';
import 'package:uit_buddy_mobile/core/theme/app_color.dart';
import 'package:uit_buddy_mobile/core/theme/app_text_style.dart';

class ChatEmptyState extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final VoidCallback? onActionTap;
  final String? actionLabel;

  const ChatEmptyState({
    super.key,
    required this.icon,
    required this.title,
    this.subtitle,
    this.onActionTap,
    this.actionLabel,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Rounded icon container with soft background
            Container(
              width: 96,
              height: 96,
              decoration: BoxDecoration(
                color: AppColor.softBlueBg,
                borderRadius: BorderRadius.circular(24),
              ),
              child: Icon(icon, size: 48, color: AppColor.primaryBlue),
            ),
            const SizedBox(height: 24),
            Text(
              title,
              style: AppTextStyle.bodyMedium.copyWith(
                fontWeight: FontWeight.w600,
                color: AppColor.primaryText,
              ),
              textAlign: TextAlign.center,
            ),
            if (subtitle != null) ...[
              const SizedBox(height: 8),
              Text(
                subtitle!,
                style: AppTextStyle.bodySmall.copyWith(
                  color: AppColor.secondaryText,
                ),
                textAlign: TextAlign.center,
              ),
            ],
            if (onActionTap != null && actionLabel != null) ...[
              const SizedBox(height: 24),
              TextButton(
                onPressed: onActionTap,
                child: Text(
                  actionLabel!,
                  style: const TextStyle(
                    color: AppColor.primaryBlue,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

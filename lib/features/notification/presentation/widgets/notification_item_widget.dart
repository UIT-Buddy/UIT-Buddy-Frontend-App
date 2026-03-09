import 'package:flutter/material.dart';
import 'package:uit_buddy_mobile/core/theme/app_color.dart';
import 'package:uit_buddy_mobile/core/theme/app_text_style.dart';
import 'package:uit_buddy_mobile/features/notification/domain/entities/notification_entity.dart';

enum _NotificationMenuAction { markAsRead, delete }

class NotificationItemWidget extends StatelessWidget {
  const NotificationItemWidget({
    super.key,
    required this.item,
    this.onMarkAsRead,
    this.onDelete,
  });

  final NotificationItemEntity item;
  final VoidCallback? onMarkAsRead;
  final VoidCallback? onDelete;

  @override
  Widget build(BuildContext context) {
    final config = _typeConfig(item.type);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Icon
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: config.bgColor,
              shape: BoxShape.circle,
            ),
            child: Icon(config.icon, color: config.iconColor, size: 20),
          ),

          const SizedBox(width: 12),

          // Title + content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.title,
                  style: AppTextStyle.bodySmall.copyWith(
                    fontWeight: item.isRead
                        ? AppTextStyle.regular
                        : AppTextStyle.bold,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  item.content,
                  style: AppTextStyle.captionMedium,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),

          if (!item.isRead)
            Icon(Icons.circle, size: 5, color: AppColor.alertRed),

          // Three-dot menu
          PopupMenuButton<_NotificationMenuAction>(
            icon: const Icon(
              Icons.more_horiz,
              color: AppColor.secondaryText,
              size: 20,
            ),
            padding: const EdgeInsets.only(left: 4),
            color: AppColor.pureWhite,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            onSelected: (action) {
              if (action == _NotificationMenuAction.markAsRead) {
                onMarkAsRead?.call();
              } else {
                onDelete?.call();
              }
            },
            itemBuilder: (_) => [
              PopupMenuItem(
                value: _NotificationMenuAction.markAsRead,
                child: Row(
                  children: [
                    const Icon(
                      Icons.done,
                      size: 18,
                      color: AppColor.primaryBlue,
                    ),
                    const SizedBox(width: 8),
                    Text('Mark as Read', style: AppTextStyle.bodySmall),
                  ],
                ),
              ),
              PopupMenuItem(
                value: _NotificationMenuAction.delete,
                child: Row(
                  children: [
                    const Icon(
                      Icons.delete_outline,
                      size: 18,
                      color: AppColor.alertRed,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Delete',
                      style: AppTextStyle.bodySmall.copyWith(
                        color: AppColor.alertRed,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  _NotificationTypeConfig _typeConfig(NotificationType type) {
    switch (type) {
      case NotificationType.system:
        return _NotificationTypeConfig(
          icon: Icons.settings_outlined,
          iconColor: AppColor.secondaryText,
          bgColor: AppColor.dividerGrey,
        );
      case NotificationType.academic:
        return _NotificationTypeConfig(
          icon: Icons.school_outlined,
          iconColor: AppColor.primaryBlue,
          bgColor: AppColor.primaryBlue10,
        );
      case NotificationType.reminder:
        return _NotificationTypeConfig(
          icon: Icons.alarm_outlined,
          iconColor: AppColor.warningOrange,
          bgColor: AppColor.warningOrange.withValues(alpha: 0.1),
        );
      case NotificationType.social:
        return _NotificationTypeConfig(
          icon: Icons.chat_bubble_outline,
          iconColor: AppColor.successGreen,
          bgColor: AppColor.successGreen10,
        );
    }
  }
}

class _NotificationTypeConfig {
  const _NotificationTypeConfig({
    required this.icon,
    required this.iconColor,
    required this.bgColor,
  });

  final IconData icon;
  final Color iconColor;
  final Color bgColor;
}

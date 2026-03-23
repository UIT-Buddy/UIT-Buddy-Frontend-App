import 'package:flutter/material.dart';
import 'package:uit_buddy_mobile/core/theme/app_color.dart';
import 'package:uit_buddy_mobile/core/theme/app_text_style.dart';
import 'package:uit_buddy_mobile/features/profile/domain/entities/group_entity.dart';

enum _GroupMenuAction { viewMembers, leaveGroup }

class GroupItemWidget extends StatelessWidget {
  const GroupItemWidget({
    super.key,
    required this.group,
    this.onJoinChat,
    this.onViewMembers,
    this.onLeaveGroup,
  });

  final GroupEntity group;
  final VoidCallback? onJoinChat;
  final VoidCallback? onViewMembers;
  final VoidCallback? onLeaveGroup;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Avatar
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColor.dividerGrey,
            ),
            child: ClipOval(
              child: Image.network(
                group.avatarUrl,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: AppColor.dividerGrey,
                    child: const Icon(
                      Icons.group,
                      color: AppColor.secondaryText,
                    ),
                  );
                },
              ),
            ),
          ),
          const SizedBox(width: 12),

          // Group info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  group.name,
                  style: AppTextStyle.bodySmall.copyWith(
                    fontWeight: AppTextStyle.bold,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  group.description,
                  style: AppTextStyle.captionMedium.copyWith(
                    color: AppColor.secondaryText,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),

          // Join chat button
          ElevatedButton(
            onPressed: onJoinChat,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColor.primaryBlue,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text(
              'Join chat',
              style: AppTextStyle.captionMedium.copyWith(
                color: AppColor.pureWhite,
                fontWeight: AppTextStyle.bold,
              ),
            ),
          ),
          const SizedBox(width: 8),

          // Three-dot menu
          PopupMenuButton<_GroupMenuAction>(
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
              if (action == _GroupMenuAction.viewMembers) {
                onViewMembers?.call();
              } else {
                onLeaveGroup?.call();
              }
            },
            itemBuilder: (_) => [
              PopupMenuItem(
                value: _GroupMenuAction.viewMembers,
                child: Row(
                  children: [
                    const Icon(
                      Icons.people_outline,
                      size: 18,
                      color: AppColor.primaryBlue,
                    ),
                    const SizedBox(width: 8),
                    Text('View members', style: AppTextStyle.bodySmall),
                  ],
                ),
              ),
              PopupMenuItem(
                value: _GroupMenuAction.leaveGroup,
                child: Row(
                  children: [
                    const Icon(
                      Icons.logout,
                      size: 18,
                      color: AppColor.alertRed,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Leave Group',
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
}

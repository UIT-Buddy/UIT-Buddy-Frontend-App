import 'package:flutter/material.dart';
import 'package:uit_buddy_mobile/core/theme/app_color.dart';
import 'package:uit_buddy_mobile/core/theme/app_text_style.dart';
import 'package:uit_buddy_mobile/features/social/domain/entities/conversation_entity.dart';

class ConversationListItem extends StatelessWidget {
  final ConversationEntity conversation;
  final VoidCallback onTap;

  const ConversationListItem({
    super.key,
    required this.conversation,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final hasUnread = conversation.unreadCount > 0;

    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: Row(
          children: [
            _buildAvatar(),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          conversation.name,
                          style: AppTextStyle.bodySmall.copyWith(
                            fontWeight: hasUnread
                                ? AppTextStyle.bold
                                : AppTextStyle.regular,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        conversation.time,
                        style: AppTextStyle.captionSmall.copyWith(
                          color: hasUnread
                              ? AppColor.primaryBlue
                              : AppColor.secondaryText,
                          fontWeight: hasUnread
                              ? AppTextStyle.medium
                              : AppTextStyle.regular,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          conversation.lastMessage,
                          style: AppTextStyle.captionLarge.copyWith(
                            color: hasUnread
                                ? AppColor.primaryText
                                : AppColor.secondaryText,
                            fontWeight: hasUnread
                                ? AppTextStyle.medium
                                : AppTextStyle.regular,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (hasUnread) ...[
                        const SizedBox(width: 8),
                        _buildUnreadBadge(conversation.unreadCount),
                      ],
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAvatar() {
    return Stack(
      children: [
        CircleAvatar(
          radius: 26,
          backgroundColor: AppColor.veryLightGrey,
          backgroundImage: NetworkImage(conversation.avatarUrl),
        ),
        if (conversation.isGroup)
          Positioned(
            right: 0,
            bottom: 0,
            child: Container(
              width: 16,
              height: 16,
              decoration: BoxDecoration(
                color: AppColor.primaryBlue,
                shape: BoxShape.circle,
                border: Border.all(color: AppColor.pureWhite, width: 1.5),
              ),
              child: const Icon(
                Icons.group,
                size: 9,
                color: AppColor.pureWhite,
              ),
            ),
          )
        else if (conversation.isOnline)
          Positioned(
            right: 1,
            bottom: 1,
            child: Container(
              width: 13,
              height: 13,
              decoration: BoxDecoration(
                color: AppColor.successGreen,
                shape: BoxShape.circle,
                border: Border.all(color: AppColor.pureWhite, width: 2),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildUnreadBadge(int count) {
    return ConstrainedBox(
      constraints: const BoxConstraints(minWidth: 20),
      child: Container(
        height: 20,
        padding: const EdgeInsets.symmetric(horizontal: 6),
        decoration: BoxDecoration(
          color: AppColor.primaryBlue,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Center(
          child: Text(
            count > 9 ? '9+' : '$count',
            style: AppTextStyle.captionSmall.copyWith(
              color: AppColor.pureWhite,
              fontWeight: AppTextStyle.bold,
            ),
          ),
        ),
      ),
    );
  }
}

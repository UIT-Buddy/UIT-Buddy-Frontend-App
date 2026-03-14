import 'package:flutter/material.dart';
import 'package:uit_buddy_mobile/core/theme/app_color.dart';
import 'package:uit_buddy_mobile/core/theme/app_text_style.dart';
import 'package:uit_buddy_mobile/features/social/domain/entities/conversation_entity.dart';
import 'package:uit_buddy_mobile/features/social/presentation/constants/chat_setting_text.dart';

class ChatSettingsHeader extends StatelessWidget {
  final ConversationEntity conversation;
  final int memberCount;

  const ChatSettingsHeader({
    super.key,
    required this.conversation,
    required this.memberCount,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColor.pureWhite,
      padding: const EdgeInsets.symmetric(vertical: 24),
      child: Column(
        children: [
          _Avatar(conversation: conversation),
          const SizedBox(height: 12),
          Text(
            conversation.name,
            style: AppTextStyle.h3.copyWith(fontWeight: AppTextStyle.bold),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 4),
          if (conversation.isGroup)
            Text(
              ChatSettingText.memberCount(memberCount),
              style: AppTextStyle.captionMedium,
            )
          else
            Text(
              conversation.isOnline
                  ? ChatSettingText.online
                  : ChatSettingText.offline,
              style: AppTextStyle.captionMedium.copyWith(
                color: conversation.isOnline
                    ? AppColor.successGreen
                    : AppColor.secondaryText,
              ),
            ),
        ],
      ),
    );
  }
}

class _Avatar extends StatelessWidget {
  final ConversationEntity conversation;

  const _Avatar({required this.conversation});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: 84,
          height: 84,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: AppColor.dividerGrey),
          ),
          child: CircleAvatar(
            radius: 42,
            backgroundColor: AppColor.veryLightGrey,
            backgroundImage: NetworkImage(conversation.avatarUrl),
          ),
        ),
        if (!conversation.isGroup)
          Positioned(
            right: 2,
            bottom: 2,
            child: Container(
              width: 16,
              height: 16,
              decoration: BoxDecoration(
                color: conversation.isOnline
                    ? AppColor.successGreen
                    : AppColor.secondaryText,
                shape: BoxShape.circle,
                border: Border.all(color: AppColor.pureWhite, width: 2),
              ),
            ),
          ),
      ],
    );
  }
}

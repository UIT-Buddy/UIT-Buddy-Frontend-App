import 'package:flutter/material.dart';
import 'package:uit_buddy_mobile/core/theme/app_color.dart';
import 'package:uit_buddy_mobile/core/theme/app_text_style.dart';
import 'package:uit_buddy_mobile/features/social/domain/entities/conversation_entity.dart';
import 'package:uit_buddy_mobile/features/social/presentation/constants/chat_setting_text.dart';

class ChatSettingsQuickActions extends StatelessWidget {
  final ConversationEntity conversation;
  final bool isMuted;
  final VoidCallback onMuteToggle;

  const ChatSettingsQuickActions({
    super.key,
    required this.conversation,
    required this.isMuted,
    required this.onMuteToggle,
  });

  @override
  Widget build(BuildContext context) {
    final items = [
      _QuickActionData(
        icon: Icons.search_rounded,
        label: ChatSettingText.search,
        onTap: () {},
      ),
      _QuickActionData(
        icon: isMuted
            ? Icons.notifications_off_outlined
            : Icons.notifications_outlined,
        label: isMuted ? ChatSettingText.unmute : ChatSettingText.mute,
        onTap: onMuteToggle,
      ),
      if (conversation.isGroup)
        _QuickActionData(
          icon: Icons.person_add_alt_1_outlined,
          label: ChatSettingText.addMember,
          onTap: () {},
        )
      else
        _QuickActionData(
          icon: Icons.group_add_outlined,
          label: ChatSettingText.createGroup,
          onTap: () {},
        ),
    ];

    return Container(
      color: AppColor.pureWhite,
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: items.map((a) => _QuickActionButton(data: a)).toList(),
      ),
    );
  }
}

class _QuickActionData {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _QuickActionData({
    required this.icon,
    required this.label,
    required this.onTap,
  });
}

class _QuickActionButton extends StatelessWidget {
  final _QuickActionData data;

  const _QuickActionButton({required this.data});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: data.onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: AppColor.primaryBlue10,
              shape: BoxShape.circle,
            ),
            child: Icon(data.icon, color: AppColor.primaryBlue, size: 24),
          ),
          const SizedBox(height: 6),
          SizedBox(
            width: 72,
            child: Text(
              data.label,
              style: AppTextStyle.captionSmall.copyWith(
                color: AppColor.primaryText,
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}

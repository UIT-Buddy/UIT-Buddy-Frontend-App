import 'package:flutter/material.dart';
import 'package:uit_buddy_mobile/core/theme/app_color.dart';
import 'package:uit_buddy_mobile/core/theme/app_text_style.dart';
import 'package:uit_buddy_mobile/features/social/domain/entities/conversation_entity.dart';
import 'package:uit_buddy_mobile/features/social/presentation/constants/chat_setting_text.dart';
import 'package:uit_buddy_mobile/features/social/presentation/widgets/settings/settings_row.dart';
import 'package:uit_buddy_mobile/features/social/presentation/widgets/settings/settings_section.dart';

class ChatSettingsPrivacySection extends StatelessWidget {
  final ConversationEntity conversation;
  final bool isMuted;
  final VoidCallback onMuteToggle;
  final VoidCallback onLeaveGroup;

  const ChatSettingsPrivacySection({
    super.key,
    required this.conversation,
    required this.isMuted,
    required this.onMuteToggle,
    required this.onLeaveGroup,
  });

  @override
  Widget build(BuildContext context) {
    return SettingsSection(
      title: ChatSettingText.privacySectionTitle,
      children: [
        SettingsRow(
          leading: SettingsIconBox(
            icon: Icons.notifications_outlined,
            bgColor: AppColor.secondaryText.withValues(alpha: 0.12),
            iconColor: AppColor.secondaryText,
          ),
          title: ChatSettingText.muteNotifications,
          trailing: Transform.scale(
            scale: 0.8,
            child: Switch(
              value: isMuted,
              onChanged: (_) => onMuteToggle(),
              activeThumbColor: AppColor.primaryBlue,
            ),
          ),
          onTap: onMuteToggle,
        ),
        const SettingsDivider(),
        SettingsRow(
          leading: SettingsIconBox(
            icon: Icons.search_outlined,
            bgColor: AppColor.primaryBlue10,
            iconColor: AppColor.primaryBlue,
          ),
          title: ChatSettingText.searchInChat,
          onTap: () {},
        ),
        const SettingsDivider(),
        if (!conversation.isGroup) ...[
          SettingsRow(
            leading: SettingsIconBox(
              icon: Icons.block_rounded,
              bgColor: AppColor.alertRed10,
              iconColor: AppColor.alertRed,
            ),
            title: ChatSettingText.block,
            subtitle: ChatSettingText.blockSubtitle,
            onTap: () {},
            titleStyle: AppTextStyle.bodySmall.copyWith(
              color: AppColor.alertRed,
            ),
          ),
          const SettingsDivider(),
        ],
        if (conversation.isGroup) ...[
          SettingsRow(
            leading: SettingsIconBox(
              icon: Icons.logout_rounded,
              bgColor: AppColor.alertRed10,
              iconColor: AppColor.alertRed,
            ),
            title: ChatSettingText.leaveGroup,
            onTap: onLeaveGroup,
            titleStyle: AppTextStyle.bodySmall.copyWith(
              color: AppColor.alertRed,
            ),
          ),
          const SettingsDivider(),
        ],
        SettingsRow(
          leading: SettingsIconBox(
            icon: Icons.flag_outlined,
            bgColor: AppColor.alertRed10,
            iconColor: AppColor.alertRed,
          ),
          title: ChatSettingText.report,
          onTap: () {},
          titleStyle: AppTextStyle.bodySmall.copyWith(color: AppColor.alertRed),
        ),
      ],
    );
  }
}

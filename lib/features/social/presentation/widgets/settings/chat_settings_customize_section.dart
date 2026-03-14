import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uit_buddy_mobile/core/theme/app_color.dart';
import 'package:uit_buddy_mobile/features/social/domain/entities/conversation_entity.dart';
import 'package:uit_buddy_mobile/features/social/presentation/bloc/chat_settings/chat_settings_bloc.dart';
import 'package:uit_buddy_mobile/features/social/presentation/bloc/chat_settings/chat_settings_state.dart';
import 'package:uit_buddy_mobile/features/social/presentation/constants/chat_setting_text.dart';
import 'package:uit_buddy_mobile/features/social/presentation/widgets/settings/chat_settings_nicknames_sheet.dart';
import 'package:uit_buddy_mobile/features/social/presentation/widgets/settings/settings_row.dart';
import 'package:uit_buddy_mobile/features/social/presentation/widgets/settings/settings_section.dart';

class ChatSettingsCustomizeSection extends StatelessWidget {
  final ConversationEntity conversation;

  const ChatSettingsCustomizeSection({super.key, required this.conversation});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChatSettingsBloc, ChatSettingsState>(
      builder: (context, state) {
        return SettingsSection(
          title: ChatSettingText.customizeSectionTitle,
          children: [
            SettingsRow(
              leading: Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: AppColor.primaryBlue10,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.badge_outlined,
                  color: AppColor.primaryBlue,
                  size: 20,
                ),
              ),
              title: ChatSettingText.nicknames,
              subtitle: ChatSettingText.nicknamesSubtitle,
              onTap: () => _showNicknamesSheet(context, state),
            ),
            const SettingsDivider(),
            SettingsRow(
              leading: Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  gradient: AppColor.primaryGradient,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.color_lens_outlined,
                  color: AppColor.pureWhite,
                  size: 20,
                ),
              ),
              title: ChatSettingText.theme,
              subtitle: ChatSettingText.themeSubtitle,
              trailing: Container(
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                  gradient: AppColor.primaryGradient,
                  shape: BoxShape.circle,
                ),
              ),
              onTap: () {},
            ),
            const SettingsDivider(),
            SettingsRow(
              leading: Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: AppColor.warningOrangeLight,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Text(
                  '👍',
                  style: TextStyle(fontSize: 18),
                  textAlign: TextAlign.center,
                ),
              ),
              title: ChatSettingText.quickEmoji,
              subtitle: ChatSettingText.quickEmojiSubtitle,
              onTap: () {},
            ),
            const SettingsDivider(),
            SettingsRow(
              leading: SettingsIconBox(
                icon: Icons.image_outlined,
                bgColor: AppColor.successGreen10,
                iconColor: AppColor.successGreen,
              ),
              title: ChatSettingText.chatPhoto,
              subtitle: conversation.isGroup
                  ? ChatSettingText.chatPhotoSubtitleGroup
                  : ChatSettingText.chatPhotoSubtitle1on1,
              onTap: () {},
            ),
          ],
        );
      },
    );
  }

  void _showNicknamesSheet(BuildContext context, ChatSettingsState state) {
    final bloc = context.read<ChatSettingsBloc>();
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => BlocProvider.value(
        value: bloc,
        child: ChatSettingsNicknamesSheet(
          conversation: conversation,
          members: state.members,
          nicknames: state.nicknames,
        ),
      ),
    );
  }
}

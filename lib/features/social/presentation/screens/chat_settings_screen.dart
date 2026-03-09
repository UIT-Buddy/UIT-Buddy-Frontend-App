import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uit_buddy_mobile/core/theme/app_color.dart';
import 'package:uit_buddy_mobile/core/theme/app_text_style.dart';
import 'package:uit_buddy_mobile/features/social/domain/entities/conversation_entity.dart';
import 'package:uit_buddy_mobile/features/social/presentation/bloc/chat_settings/chat_settings_bloc.dart';
import 'package:uit_buddy_mobile/features/social/presentation/bloc/chat_settings/chat_settings_event.dart';
import 'package:uit_buddy_mobile/features/social/presentation/bloc/chat_settings/chat_settings_state.dart';
import 'package:uit_buddy_mobile/features/social/presentation/constants/chat_setting_text.dart';
import 'package:uit_buddy_mobile/features/social/presentation/widgets/settings/chat_settings_header.dart';
import 'package:uit_buddy_mobile/features/social/presentation/widgets/settings/chat_settings_media_section.dart';
import 'package:uit_buddy_mobile/features/social/presentation/widgets/settings/chat_settings_members_section.dart';
import 'package:uit_buddy_mobile/features/social/presentation/widgets/settings/chat_settings_privacy_section.dart';
import 'package:uit_buddy_mobile/features/social/presentation/widgets/settings/chat_settings_quick_actions.dart';

class ChatSettingsScreen extends StatelessWidget {
  final ConversationEntity conversation;

  const ChatSettingsScreen({super.key, required this.conversation});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          ChatSettingsBloc()
            ..add(ChatSettingsStarted(conversation: conversation)),
      child: _ChatSettingsView(conversation: conversation),
    );
  }
}

class _ChatSettingsView extends StatelessWidget {
  final ConversationEntity conversation;

  const _ChatSettingsView({required this.conversation});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.veryLightGrey,
      appBar: _buildAppBar(context),
      body: BlocBuilder<ChatSettingsBloc, ChatSettingsState>(
        builder: (context, state) {
          if (state.status == ChatSettingsStatus.loading ||
              state.status == ChatSettingsStatus.initial) {
            return const Center(
              child: CircularProgressIndicator(
                color: AppColor.primaryBlue,
                strokeWidth: 2,
              ),
            );
          }
          return _buildBody(context, state);
        },
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: AppColor.veryLightGrey,
      elevation: 0,
      scrolledUnderElevation: 0,
      leadingWidth: 44,
      leading: IconButton(
        icon: const Icon(
          Icons.arrow_back_ios,
          size: 20,
          color: AppColor.primaryText,
        ),
        onPressed: () => Navigator.of(context).pop(),
        padding: const EdgeInsets.only(left: 12),
      ),
      title: Text(
        ChatSettingText.appBarTitle,
        style: AppTextStyle.bodySmall.copyWith(fontWeight: AppTextStyle.bold),
      ),
      centerTitle: true,
    );
  }

  Widget _buildBody(BuildContext context, ChatSettingsState state) {
    return ListView(
      padding: EdgeInsets.zero,
      children: [
        ChatSettingsHeader(
          conversation: conversation,
          memberCount: state.members.length,
        ),
        const SizedBox(height: 8),
        ChatSettingsQuickActions(
          conversation: conversation,
          isMuted: state.isMuted,
          onMuteToggle: () => context.read<ChatSettingsBloc>().add(
            const ChatSettingsNotificationToggled(),
          ),
        ),
        const SizedBox(height: 8),
        // ChatSettingsCustomizeSection(conversation: conversation),
        if (conversation.isGroup) ...[
          const SizedBox(height: 8),
          ChatSettingsMembersSection(members: state.members),
        ],
        const SizedBox(height: 8),
        ChatSettingsMediaSection(
          sharedMedia: state.sharedMedia,
          sharedFiles: state.sharedFiles,
          selectedTab: state.selectedMediaTab,
          onTabChanged: (i) => context.read<ChatSettingsBloc>().add(
            ChatSettingsMediaTabChanged(tabIndex: i),
          ),
        ),

        const SizedBox(height: 8),
        ChatSettingsPrivacySection(
          conversation: conversation,
          isMuted: state.isMuted,
          onMuteToggle: () => context.read<ChatSettingsBloc>().add(
            const ChatSettingsNotificationToggled(),
          ),
          onLeaveGroup: () => _showLeaveGroupDialog(context),
        ),
        const SizedBox(height: 32),
      ],
    );
  }

  void _showLeaveGroupDialog(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          ChatSettingText.leaveGroupTitle,
          style: AppTextStyle.bodySmall.copyWith(fontWeight: AppTextStyle.bold),
        ),
        content: Text(
          ChatSettingText.leaveGroupBody,
          style: AppTextStyle.bodySmall.copyWith(color: AppColor.secondaryText),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text(
              ChatSettingText.cancel,
              style: AppTextStyle.bodySmall.copyWith(
                color: AppColor.secondaryText,
              ),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text(
              ChatSettingText.leaveConfirm,
              style: AppTextStyle.bodySmall.copyWith(
                color: AppColor.alertRed,
                fontWeight: AppTextStyle.medium,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

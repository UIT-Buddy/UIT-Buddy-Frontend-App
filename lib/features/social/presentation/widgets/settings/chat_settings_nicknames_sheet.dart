import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uit_buddy_mobile/core/theme/app_color.dart';
import 'package:uit_buddy_mobile/core/theme/app_text_style.dart';
import 'package:uit_buddy_mobile/features/social/domain/entities/chat_member_entity.dart';
import 'package:uit_buddy_mobile/features/social/domain/entities/conversation_entity.dart';
import 'package:uit_buddy_mobile/features/social/presentation/bloc/chat_settings/chat_settings_bloc.dart';
import 'package:uit_buddy_mobile/features/social/presentation/bloc/chat_settings/chat_settings_event.dart';
import 'package:uit_buddy_mobile/features/social/presentation/constants/chat_setting_text.dart';

class ChatSettingsNicknamesSheet extends StatelessWidget {
  final ConversationEntity conversation;
  final List<ChatMemberEntity> members;
  final Map<String, String> nicknames;

  const ChatSettingsNicknamesSheet({
    super.key,
    required this.conversation,
    required this.members,
    required this.nicknames,
  });

  List<ChatMemberEntity> _displayMembers() {
    if (members.isNotEmpty) return members;
    return [
      const ChatMemberEntity(
        id: 'me',
        name: 'Me',
        avatarUrl: 'https://i.pravatar.cc/150?img=3',
      ),
      ChatMemberEntity(
        id: 'other',
        name: conversation.name,
        avatarUrl: conversation.avatarUrl,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColor.pureWhite,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 8),
          Container(
            width: 36,
            height: 4,
            decoration: BoxDecoration(
              color: AppColor.dividerGrey,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Text(
                  ChatSettingText.nicknameSheetTitle,
                  style: AppTextStyle.bodySmall.copyWith(
                    fontWeight: AppTextStyle.bold,
                  ),
                ),
                const Spacer(),
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text(
                    ChatSettingText.nicknameSheetDone,
                    style: AppTextStyle.bodySmall.copyWith(
                      color: AppColor.primaryBlue,
                      fontWeight: AppTextStyle.medium,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1, color: AppColor.dividerGrey),
          ..._displayMembers().map(
            (m) => _NicknameRow(
              member: m,
              currentNickname: nicknames[m.id],
              onTap: () => _editNickname(context, m),
            ),
          ),
          SizedBox(height: MediaQuery.of(context).padding.bottom + 8),
        ],
      ),
    );
  }

  void _editNickname(BuildContext context, ChatMemberEntity member) {
    final controller = TextEditingController(text: nicknames[member.id] ?? '');
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          ChatSettingText.setNicknameFor(member.name),
          style: AppTextStyle.bodySmall.copyWith(fontWeight: AppTextStyle.bold),
        ),
        content: TextField(
          controller: controller,
          autofocus: true,
          style: AppTextStyle.bodySmall,
          decoration: InputDecoration(
            hintText: ChatSettingText.nicknameHint,
            hintStyle: AppTextStyle.bodySmall.copyWith(
              color: AppColor.secondaryText,
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 10,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: AppColor.dividerGrey),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: AppColor.primaryBlue),
            ),
          ),
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
            onPressed: () {
              context.read<ChatSettingsBloc>().add(
                ChatSettingsNicknameUpdated(
                  userId: member.id,
                  nickname: controller.text.trim(),
                ),
              );
              Navigator.of(ctx).pop();
            },
            child: Text(
              ChatSettingText.save,
              style: AppTextStyle.bodySmall.copyWith(
                color: AppColor.primaryBlue,
                fontWeight: AppTextStyle.medium,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _NicknameRow extends StatelessWidget {
  final ChatMemberEntity member;
  final String? currentNickname;
  final VoidCallback onTap;

  const _NicknameRow({
    required this.member,
    this.currentNickname,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            CircleAvatar(
              radius: 20,
              backgroundColor: AppColor.veryLightGrey,
              backgroundImage: NetworkImage(member.avatarUrl),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(member.name, style: AppTextStyle.bodySmall),
                  if (currentNickname != null && currentNickname!.isNotEmpty)
                    Text(
                      currentNickname!,
                      style: AppTextStyle.captionMedium.copyWith(
                        color: AppColor.primaryBlue,
                      ),
                    )
                  else
                    Text(
                      ChatSettingText.addNickname,
                      style: AppTextStyle.captionMedium,
                    ),
                ],
              ),
            ),
            const Icon(
              Icons.edit_outlined,
              color: AppColor.secondaryText,
              size: 18,
            ),
          ],
        ),
      ),
    );
  }
}

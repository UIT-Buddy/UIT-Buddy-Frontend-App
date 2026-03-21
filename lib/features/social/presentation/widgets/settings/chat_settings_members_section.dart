import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:uit_buddy_mobile/core/theme/app_color.dart';
import 'package:uit_buddy_mobile/core/theme/app_text_style.dart';
import 'package:uit_buddy_mobile/features/social/domain/entities/chat_member_entity.dart';
import 'package:uit_buddy_mobile/features/social/presentation/constants/chat_setting_text.dart';
import 'package:uit_buddy_mobile/features/social/presentation/widgets/settings/settings_row.dart';
import 'package:uit_buddy_mobile/features/social/presentation/widgets/settings/settings_section.dart';

class ChatSettingsMembersSection extends StatelessWidget {
  final List<ChatMemberEntity> members;
  final VoidCallback onAddMember;

  const ChatSettingsMembersSection({
    super.key,
    required this.members,
    required this.onAddMember,
  });

  @override
  Widget build(BuildContext context) {
    return SettingsSection(
      title: ChatSettingText.membersSectionTitle(members.length),
      children: [
        ...members.asMap().entries.map((entry) {
          final i = entry.key;
          final member = entry.value;
          return Column(
            children: [
              _MemberRow(member: member),
              if (i < members.length - 1) const SettingsDivider(),
            ],
          );
        }),
        const SettingsDivider(),
        SettingsRow(
          leading: SettingsIconBox(
            icon: Icons.person_add_alt_1_rounded,
            bgColor: AppColor.primaryBlue10,
            iconColor: AppColor.primaryBlue,
          ),
          title: ChatSettingText.addMemberAction,
          onTap: onAddMember,
          titleStyle: AppTextStyle.bodySmall.copyWith(
            color: AppColor.primaryBlue,
            fontWeight: AppTextStyle.medium,
          ),
        ),
      ],
    );
  }
}

class _MemberRow extends StatelessWidget {
  final ChatMemberEntity member;

  const _MemberRow({required this.member});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {},
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: Row(
          children: [
            Stack(
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundColor: AppColor.veryLightGrey,
                  backgroundImage: CachedNetworkImageProvider(member.avatarUrl),
                ),
                if (member.isOnline)
                  Positioned(
                    right: 0,
                    bottom: 0,
                    child: Container(
                      width: 10,
                      height: 10,
                      decoration: BoxDecoration(
                        color: AppColor.successGreen,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: AppColor.pureWhite,
                          width: 1.5,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    member.nickname ?? member.name,
                    style: AppTextStyle.bodySmall.copyWith(
                      color: AppColor.primaryText,
                    ),
                  ),
                  if (member.nickname != null) ...[
                    const SizedBox(height: 1),
                    Text(member.name, style: AppTextStyle.captionMedium),
                  ],
                ],
              ),
            ),
            if (member.isAdmin)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: AppColor.primaryBlue10,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  ChatSettingText.adminBadge,
                  style: AppTextStyle.captionSmall.copyWith(
                    color: AppColor.primaryBlue,
                    fontWeight: AppTextStyle.medium,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

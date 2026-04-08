import 'package:flutter/material.dart';
import 'package:uit_buddy_mobile/core/theme/app_color.dart';
import 'package:uit_buddy_mobile/core/theme/app_text_style.dart';
import 'package:uit_buddy_mobile/features/profile/presentation/bloc/your_friends_screen/friends_state.dart';

class FriendsPrimaryTabs extends StatelessWidget {
  const FriendsPrimaryTabs({
    super.key,
    required this.current,
    required this.onChanged,
  });

  final FriendsPrimaryTab current;
  final ValueChanged<FriendsPrimaryTab> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 14),
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: AppColor.dividerGrey,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Expanded(
            child: _SegmentButton(
              label: 'Your friends',
              selected: current == FriendsPrimaryTab.friends,
              onTap: () => onChanged(FriendsPrimaryTab.friends),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: _SegmentButton(
              label: 'Invites',
              selected: current == FriendsPrimaryTab.invites,
              onTap: () => onChanged(FriendsPrimaryTab.invites),
            ),
          ),
        ],
      ),
    );
  }
}

class FriendsInviteTabs extends StatelessWidget {
  const FriendsInviteTabs({
    super.key,
    required this.current,
    required this.onChanged,
  });

  final FriendsInviteTab current;
  final ValueChanged<FriendsInviteTab> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 14),
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: AppColor.dividerGrey,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Expanded(
            child: _SegmentButton(
              label: 'Sent',
              selected: current == FriendsInviteTab.sent,
              onTap: () => onChanged(FriendsInviteTab.sent),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: _SegmentButton(
              label: 'Received',
              selected: current == FriendsInviteTab.received,
              onTap: () => onChanged(FriendsInviteTab.received),
            ),
          ),
        ],
      ),
    );
  }
}

class _SegmentButton extends StatelessWidget {
  const _SegmentButton({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        curve: Curves.easeOut,
        padding: const EdgeInsets.symmetric(vertical: 7),
        decoration: BoxDecoration(
          color: selected ? AppColor.primaryBlue : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
          border: selected
              ? Border.all(color: AppColor.dividerGrey)
              : Border.all(color: AppColor.dividerGrey, width: 1),
        ),
        child: Center(
          child: Text(
            label,
            style: AppTextStyle.bodySmall.copyWith(
              fontWeight: selected ? AppTextStyle.bold : AppTextStyle.medium,
              color: selected ? AppColor.pureWhite : AppColor.secondaryText,
            ),
          ),
        ),
      ),
    );
  }
}

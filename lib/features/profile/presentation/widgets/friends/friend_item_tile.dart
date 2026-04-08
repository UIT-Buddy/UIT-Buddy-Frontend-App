import 'package:flutter/material.dart';
import 'package:uit_buddy_mobile/core/theme/app_color.dart';
import 'package:uit_buddy_mobile/core/theme/app_text_style.dart';
import 'package:uit_buddy_mobile/features/profile/domain/entities/friend_entity.dart';

enum _FriendMenuAction { viewProfile, unfriend }

class FriendItemTile extends StatelessWidget {
  const FriendItemTile({
    super.key,
    required this.friend,
    required this.showUnfriendAction,
    required this.isActionLoading,
    required this.disableActions,
    required this.onViewProfile,
    this.actionLabel,
    this.onActionPressed,
    this.onUnfriend,
  });

  final FriendEntity friend;
  final bool showUnfriendAction;
  final String? actionLabel;
  final bool isActionLoading;
  final bool disableActions;
  final VoidCallback onViewProfile;
  final VoidCallback? onActionPressed;
  final VoidCallback? onUnfriend;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        children: [
          GestureDetector(
            onTap: onViewProfile,
            child: _Avatar(avatarUrl: friend.avatarUrl),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  friend.name,
                  style: AppTextStyle.bodyLarge.copyWith(
                    fontWeight: AppTextStyle.bold,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'MSSV ${friend.mssv}',
                  style: AppTextStyle.bodySmall.copyWith(
                    color: AppColor.secondaryText,
                  ),
                ),
              ],
            ),
          ),
          if (actionLabel != null) ...[
            SizedBox(
              height: 30,
              child: ElevatedButton(
                onPressed: disableActions || isActionLoading
                    ? null
                    : onActionPressed,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColor.primaryBlue10,
                  foregroundColor: AppColor.primaryBlue,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  textStyle: AppTextStyle.bodySmall.copyWith(
                    fontWeight: AppTextStyle.medium,
                  ),
                ),
                child: isActionLoading
                    ? const SizedBox(
                        width: 14,
                        height: 14,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : Text(actionLabel!),
              ),
            ),
            const SizedBox(width: 8),
          ],
          if (isActionLoading && actionLabel == null)
            const SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(strokeWidth: 2),
            )
          else
            PopupMenuButton<_FriendMenuAction>(
              enabled: !disableActions,
              icon: const Icon(Icons.more_horiz, color: AppColor.secondaryText),
              onSelected: (action) {
                if (action == _FriendMenuAction.viewProfile) {
                  onViewProfile();
                } else {
                  onUnfriend?.call();
                }
              },
              itemBuilder: (_) => [
                PopupMenuItem(
                  value: _FriendMenuAction.viewProfile,
                  child: Row(
                    children: [
                      const Icon(Icons.person_outline, size: 18),
                      const SizedBox(width: 8),
                      Text('View profile', style: AppTextStyle.bodySmall),
                    ],
                  ),
                ),
                if (showUnfriendAction)
                  PopupMenuItem(
                    value: _FriendMenuAction.unfriend,
                    child: Row(
                      children: [
                        const Icon(
                          Icons.person_remove_outlined,
                          size: 18,
                          color: AppColor.alertRed,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Unfriend',
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

class _Avatar extends StatelessWidget {
  const _Avatar({required this.avatarUrl});

  final String avatarUrl;

  @override
  Widget build(BuildContext context) {
    final hasAvatar = avatarUrl.trim().isNotEmpty;

    return Container(
      width: 54,
      height: 54,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: AppColor.primaryText, width: 1),
        color: AppColor.pureWhite,
      ),
      child: ClipOval(
        child: hasAvatar
            ? Image.network(
                avatarUrl,
                fit: BoxFit.cover,
                errorBuilder: (_, _, _) => const Icon(
                  Icons.person,
                  color: AppColor.secondaryText,
                  size: 30,
                ),
              )
            : const Icon(Icons.person, color: AppColor.secondaryText, size: 30),
      ),
    );
  }
}

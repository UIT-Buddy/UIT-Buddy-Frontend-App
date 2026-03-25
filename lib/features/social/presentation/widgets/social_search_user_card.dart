import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:uit_buddy_mobile/core/theme/app_color.dart';
import 'package:uit_buddy_mobile/core/theme/app_text_style.dart';
import 'package:uit_buddy_mobile/features/social/domain/entities/search_user_entity.dart';

class SocialSearchUserCard extends StatelessWidget {
  const SocialSearchUserCard({super.key, required this.user, this.onTap});

  final SearchUserEntity user;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final buttonStyle = _FriendStatusButtonStyle.fromStatus(user.friendStatus);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColor.pureWhite,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: AppColor.dividerGrey),
          boxShadow: const [
            BoxShadow(
              color: AppColor.shadowColor,
              blurRadius: 14,
              offset: Offset(0, 6),
            ),
          ],
        ),
        child: Row(
          children: [
            _buildAvatar(),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    user.fullName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyle.bodyMedium.copyWith(
                      fontWeight: AppTextStyle.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text('MSSV ${user.mssv}', style: AppTextStyle.captionLarge),
                ],
              ),
            ),
            Container(
              constraints: const BoxConstraints(minWidth: 94),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: buttonStyle.backgroundColor,
                border: Border.all(color: buttonStyle.borderColor),
                borderRadius: BorderRadius.circular(999),
              ),
              child: Text(
                user.friendStatus.label,
                textAlign: TextAlign.center,
                style: AppTextStyle.captionLarge.copyWith(
                  color: buttonStyle.foregroundColor,
                  fontWeight: AppTextStyle.medium,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAvatar() {
    final avatarUrl = user.avatarUrl;
    if (avatarUrl != null && avatarUrl.isNotEmpty) {
      return ClipOval(
        child: CachedNetworkImage(
          imageUrl: avatarUrl,
          width: 52,
          height: 52,
          fit: BoxFit.cover,
          errorWidget: (_, _, _) => _buildFallbackAvatar(),
        ),
      );
    }

    return _buildFallbackAvatar();
  }

  Widget _buildFallbackAvatar() {
    return Container(
      width: 52,
      height: 52,
      decoration: BoxDecoration(
        gradient: AppColor.blueAvatarGradient,
        shape: BoxShape.circle,
      ),
      alignment: Alignment.center,
      child: Text(
        user.avatarLetter,
        style: AppTextStyle.bodyMedium.copyWith(
          color: AppColor.pureWhite,
          fontWeight: AppTextStyle.bold,
        ),
      ),
    );
  }
}

class _FriendStatusButtonStyle {
  const _FriendStatusButtonStyle({
    required this.backgroundColor,
    required this.foregroundColor,
    required this.borderColor,
  });

  final Color backgroundColor;
  final Color foregroundColor;
  final Color borderColor;

  factory _FriendStatusButtonStyle.fromStatus(FriendStatus status) {
    return switch (status) {
      FriendStatus.none => _FriendStatusButtonStyle(
        backgroundColor: AppColor.primaryBlue,
        foregroundColor: AppColor.pureWhite,
        borderColor: AppColor.primaryBlue,
      ),
      FriendStatus.pending => _FriendStatusButtonStyle(
        backgroundColor: AppColor.veryLightGrey,
        foregroundColor: AppColor.secondaryText,
        borderColor: AppColor.dividerGrey,
      ),
      FriendStatus.friends => _FriendStatusButtonStyle(
        backgroundColor: AppColor.primaryBlue10,
        foregroundColor: AppColor.primaryBlue,
        borderColor: AppColor.primaryBlue10,
      ),
    };
  }
}

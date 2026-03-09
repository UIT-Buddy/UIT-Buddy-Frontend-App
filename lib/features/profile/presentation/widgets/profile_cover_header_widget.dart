import 'package:flutter/material.dart';
import 'package:uit_buddy_mobile/core/theme/app_color.dart';
import 'package:uit_buddy_mobile/core/theme/app_text_style.dart';
import 'package:uit_buddy_mobile/features/profile/domain/entities/profile_entity.dart';

class ProfileCoverHeaderWidget extends StatelessWidget {
  const ProfileCoverHeaderWidget({
    super.key,
    required this.profileInfo,
    this.onNotificationTap,
    this.onSettingsTap,
  });

  final ProfileEntity profileInfo;
  final VoidCallback? onNotificationTap;
  final VoidCallback? onSettingsTap;

  static const double _coverHeight = 150.0;
  static const double _avatarRadius = 48.0;
  static const double _avatarOverlap = _avatarRadius;

  @override
  Widget build(BuildContext context) {
    final topPadding = MediaQuery.of(context).padding.top;

    return Column(
      children: [
        Stack(
          clipBehavior: Clip.none,
          children: [
            // Cover image
            SizedBox(
              height: _coverHeight + topPadding,
              width: double.infinity,
              child: Image.asset(
                profileInfo.coverUrl,
                fit: BoxFit.cover,
                errorBuilder: (_, _, _) => Image.asset(
                  'assets/images/placeholder/bg-placeholder-transparent.png',
                  fit: BoxFit.cover,
                ),
              ),
            ),

            // Top bar icons
            Positioned(
              top: topPadding + 8,
              left: 12,
              child: _CircleIconButton(
                icon: Icons.notifications_outlined,
                onTap: onNotificationTap,
              ),
            ),
            Positioned(
              top: topPadding + 8,
              right: 12,
              child: _CircleIconButton(
                icon: Icons.settings_outlined,
                onTap: onSettingsTap,
              ),
            ),

            // Avatar overlapping the cover bottom
            Positioned(
              bottom: -_avatarOverlap,
              left: 0,
              right: 0,
              child: Center(
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: AppColor.pureWhite, width: 3),
                    boxShadow: const [
                      BoxShadow(
                        color: AppColor.shadowColor,
                        blurRadius: 8,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: CircleAvatar(
                    radius: _avatarRadius,
                    backgroundImage: AssetImage(profileInfo.avatarUrl),
                    onBackgroundImageError: (_, _) {},
                    child: _isValidAsset(profileInfo.avatarUrl)
                        ? null
                        : Image.asset(
                            'assets/images/placeholder/user-icon.png',
                          ),
                  ),
                ),
              ),
            ),
          ],
        ),

        // Spacer for avatar overlap
        const SizedBox(height: _avatarOverlap + 8),

        // Name
        Text(
          profileInfo.fullName,
          style: AppTextStyle.h3.copyWith(fontWeight: AppTextStyle.bold),
        ),
        const SizedBox(height: 2),

        // MSSV
        Text('MSSV: ${profileInfo.mssv}', style: AppTextStyle.captionMedium),
        const SizedBox(height: 16),
      ],
    );
  }

  bool _isValidAsset(String path) => path.isNotEmpty;
}

class _CircleIconButton extends StatelessWidget {
  const _CircleIconButton({required this.icon, this.onTap});

  final IconData icon;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: Colors.black.withValues(alpha: 0.25),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: AppColor.pureWhite, size: 20),
      ),
    );
  }
}

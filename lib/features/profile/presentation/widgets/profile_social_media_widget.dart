import 'package:flutter/material.dart';
import 'package:uit_buddy_mobile/core/theme/app_color.dart';
import 'package:uit_buddy_mobile/core/theme/app_text_style.dart';
import 'package:uit_buddy_mobile/features/profile/domain/entities/profile_entity.dart';
import 'package:uit_buddy_mobile/features/profile/presentation/constants/profile_text.dart';

class ProfileSocialMediaWidget extends StatelessWidget {
  const ProfileSocialMediaWidget({
    super.key,
    required this.profileInfo,
    this.onViewPostsTap,
  });

  final ProfileEntity profileInfo;
  final VoidCallback? onViewPostsTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColor.pureWhite,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: AppColor.shadowColor,
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            ProfileText.socialMedia,
            style: AppTextStyle.h4.copyWith(fontWeight: AppTextStyle.bold),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _GreenStatCard(
                  value: '${profileInfo.stats.posts}',
                  label: ProfileText.posts,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _GreenStatCard(
                  value: '${profileInfo.stats.comments}',
                  label: ProfileText.comments,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: onViewPostsTap,
              style: OutlinedButton.styleFrom(
                side: BorderSide(
                  color: AppColor.successGreen.withOpacity(0.4),
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
              child: Text(
                ProfileText.viewPosts,
                style: AppTextStyle.bodyLargeBlue.copyWith(
                  color: AppColor.successGreen,
                  fontWeight: AppTextStyle.medium,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _GreenStatCard extends StatelessWidget {
  const _GreenStatCard({required this.value, required this.label});

  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
      decoration: BoxDecoration(
        gradient: AppColor.greenAvatarGradient,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            value,
            style: AppTextStyle.heroNumberWhite.copyWith(
              fontWeight: AppTextStyle.bold,
              fontSize: 28,
            ),
          ),
          const SizedBox(height: 4),
          Text(label, style: AppTextStyle.captionSmallWhite.copyWith(fontSize: 13)),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:uit_buddy_mobile/core/theme/app_color.dart';
import 'package:uit_buddy_mobile/core/theme/app_text_style.dart';
import 'package:uit_buddy_mobile/features/profile/domain/entities/profile_entity.dart';
import 'package:uit_buddy_mobile/features/profile/presentation/constants/profile_text.dart';

class ProfileAcademicSummaryWidget extends StatelessWidget {
  const ProfileAcademicSummaryWidget({
    super.key,
    required this.profileInfo,
    this.onSeeDetailsTap,
  });

  final ProfileEntity profileInfo;
  final VoidCallback? onSeeDetailsTap;

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
            ProfileText.academicSummary,
            style: AppTextStyle.h4.copyWith(fontWeight: AppTextStyle.bold),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _BlueStatCard(
                  mainValue: profileInfo.stats.gpaOn4Scale.toStringAsFixed(1),
                  subValue:
                      '(${profileInfo.stats.currentGpa.toStringAsFixed(1)})',
                  label: ProfileText.overallGpa,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _BlueStatCard(
                  mainValue:
                      '${profileInfo.stats.accumulatedCredits}/${profileInfo.stats.totalCredits}',
                  label: ProfileText.creditsAccumulated,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _OutlinedActionButton(
            label: ProfileText.seeDetails,
            color: AppColor.primaryBlue,
            onTap: onSeeDetailsTap,
          ),
        ],
      ),
    );
  }
}

class _BlueStatCard extends StatelessWidget {
  const _BlueStatCard({
    required this.mainValue,
    this.subValue,
    required this.label,
  });

  final String mainValue;
  final String? subValue;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
      decoration: BoxDecoration(
        gradient: AppColor.primaryGradient,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            mainValue,
            style: AppTextStyle.heroNumberWhite.copyWith(
              fontWeight: AppTextStyle.bold,
              fontSize: 28,
            ),
          ),
          if (subValue != null) ...[
            const SizedBox(height: 2),
            Text(
              subValue!,
              style: AppTextStyle.captionSmallWhite.copyWith(fontSize: 13),
            ),
          ],
          const SizedBox(height: 4),
          Text(
            label,
            style: AppTextStyle.captionSmallWhite.copyWith(fontSize: 13),
          ),
        ],
      ),
    );
  }
}

class _OutlinedActionButton extends StatelessWidget {
  const _OutlinedActionButton({
    required this.label,
    required this.color,
    this.onTap,
  });

  final String label;
  final Color color;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton(
        onPressed: onTap,
        style: OutlinedButton.styleFrom(
          side: BorderSide(color: color.withValues(alpha: 0.4)),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(vertical: 12),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '$label  →',
              style: AppTextStyle.bodyLargeBlue.copyWith(
                color: color,
                fontWeight: AppTextStyle.medium,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

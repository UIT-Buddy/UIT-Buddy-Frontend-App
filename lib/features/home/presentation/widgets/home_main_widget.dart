import 'package:flutter/material.dart';
import 'package:uit_buddy_mobile/core/theme/app_color.dart';
import 'package:uit_buddy_mobile/core/theme/app_text_style.dart';
import 'package:uit_buddy_mobile/features/home/presentation/constants/home_text.dart';

class HomeMainWidget extends StatelessWidget {
  const HomeMainWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: AppColor.primaryGradient,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top row: incoming badge + avatars
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: AppColor.pureWhite.withValues(alpha: 0.6),
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  HomeText.incomingBadge,
                  style: AppTextStyle.captionSmallWhite.copyWith(
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.4,
                  ),
                ),
              ),
              const Spacer(),
              const _AvatarStack(extraCount: 12),
            ],
          ),
          const SizedBox(height: 20),
          // Course code
          Text(
            HomeText.nextClassCode,
            style: AppTextStyle.h1.copyWith(
              color: AppColor.pureWhite,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 6),
          // Course name
          Text(
            HomeText.nextClassName,
            style: AppTextStyle.bodyLarge.copyWith(
              color: AppColor.pureWhite.withValues(alpha: 0.9),
              fontWeight: FontWeight.w500,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 20),
          // Room
          _InfoRow(icon: Icons.room_outlined, label: HomeText.nextClassRoom),
          const SizedBox(height: 8),
          // Lecturer
          _InfoRow(
            icon: Icons.person_outline,
            label: HomeText.nextClassLecturer,
          ),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: AppColor.pureWhite.withValues(alpha: 0.8), size: 16),
        const SizedBox(width: 6),
        Text(
          label,
          style: AppTextStyle.bodySmall.copyWith(
            color: AppColor.pureWhite.withValues(alpha: 0.85),
          ),
        ),
      ],
    );
  }
}

class _AvatarStack extends StatelessWidget {
  const _AvatarStack({this.extraCount = 12});

  final int extraCount;

  static const List<Color> _avatarColors = [
    Color(0xFF5E5CE6),
    Color(0xFF30D158),
  ];

  @override
  Widget build(BuildContext context) {
    const double size = 32;
    const double overlap = 15;
    // 2 person avatars + 1 count bubble
    const int total = 3;

    return SizedBox(
      width: size + (size - overlap) * (total - 1),
      height: size,
      child: Stack(
        children: [
          // Person avatars
          for (int i = 0; i < _avatarColors.length; i++)
            Positioned(
              left: i * (size - overlap),
              child: Container(
                width: size,
                height: size,
                decoration: BoxDecoration(
                  color: _avatarColors[i],
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColor.primaryBlueDark, width: 2),
                ),
                child: const Center(
                  child: Text('\u{1F464}', style: TextStyle(fontSize: 14)),
                ),
              ),
            ),
          // Count bubble (last position)
          Positioned(
            left: _avatarColors.length * (size - overlap),
            child: Container(
              width: size,
              height: size,
              decoration: BoxDecoration(
                color: AppColor.primaryText.withValues(alpha: 0.9),
                shape: BoxShape.circle,
                border: Border.all(color: AppColor.primaryBlueDark, width: 2),
              ),
              child: Center(
                child: Text(
                  '+$extraCount',
                  style: AppTextStyle.captionExtraSmallWhite.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

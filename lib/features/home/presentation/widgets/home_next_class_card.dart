import 'package:flutter/material.dart';
import 'package:uit_buddy_mobile/core/theme/app_color.dart';
import 'package:uit_buddy_mobile/core/theme/app_text_style.dart';
import 'package:uit_buddy_mobile/features/home/domain/entities/home_next_class_entity.dart';
import 'package:uit_buddy_mobile/features/home/presentation/constants/home_text.dart';

class HomeNextClassCard extends StatelessWidget {
  const HomeNextClassCard({super.key, required this.entity});

  final HomeNextClassEntity entity;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: AppColor.primaryGradient,
        borderRadius: BorderRadius.circular(20),
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _IncomingBadge(minutes: entity.minutesUntilStart),
              _MemberAvatars(count: entity.memberCount),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            '${entity.courseCode}\n${entity.courseName}',
            style: AppTextStyle.h2White.copyWith(
              fontWeight: AppTextStyle.bold,
              height: 1.3,
            ),
          ),
          const SizedBox(height: 16),
          _InfoRow(icon: Icons.location_on_outlined, label: entity.room),
          const SizedBox(height: 6),
          _InfoRow(icon: Icons.school_outlined, label: entity.lecturer),
        ],
      ),
    );
  }
}

class _IncomingBadge extends StatelessWidget {
  const _IncomingBadge({required this.minutes});

  final int minutes;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.25),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        '${HomeText.incoming} ($minutes ${HomeText.mins})',
        style: AppTextStyle.captionSmallWhite.copyWith(
          fontWeight: AppTextStyle.medium,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}

class _MemberAvatars extends StatelessWidget {
  const _MemberAvatars({required this.count});

  final int count;

  static const int _maxVisible = 3;
  static const double _avatarSize = 28;
  static const double _overlap = 10;

  @override
  Widget build(BuildContext context) {
    final visibleCount = count > _maxVisible ? _maxVisible : count;
    final extraCount = count - visibleCount;
    final totalItems = visibleCount + (extraCount > 0 ? 1 : 0);
    final width = _avatarSize + (totalItems - 1) * (_avatarSize - _overlap);

    return SizedBox(
      width: width,
      height: _avatarSize,
      child: Stack(
        children: [
          for (int i = 0; i < visibleCount; i++)
            Positioned(
              left: i * (_avatarSize - _overlap),
              child: _AvatarCircle(index: i),
            ),
          if (extraCount > 0)
            Positioned(
              left: visibleCount * (_avatarSize - _overlap),
              child: _ExtraBadge(count: extraCount),
            ),
        ],
      ),
    );
  }
}

class _AvatarCircle extends StatelessWidget {
  const _AvatarCircle({required this.index});

  final int index;

  static const _colors = [
    Color(0xFF5E9BF0),
    Color(0xFF7BB3F5),
    Color(0xFF99C5FA),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 28,
      height: 28,
      decoration: BoxDecoration(
        color: _colors[index % _colors.length],
        shape: BoxShape.circle,
        border: Border.all(color: AppColor.primaryBlue, width: 1.5),
      ),
      child: const Icon(Icons.person, color: Colors.white, size: 16),
    );
  }
}

class _ExtraBadge extends StatelessWidget {
  const _ExtraBadge({required this.count});

  final int count;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 28,
      height: 28,
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.3),
        shape: BoxShape.circle,
        border: Border.all(color: AppColor.primaryBlue, width: 1.5),
      ),
      alignment: Alignment.center,
      child: Text(
        '+$count',
        style: AppTextStyle.captionExtraSmallWhite.copyWith(
          fontWeight: AppTextStyle.medium,
        ),
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
        Icon(icon, color: Colors.white.withValues(alpha: 0.8), size: 16),
        const SizedBox(width: 6),
        Expanded(
          child: Text(
            label,
            style: AppTextStyle.captionSmallWhite.copyWith(
              color: Colors.white.withValues(alpha: 0.9),
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:uit_buddy_mobile/core/theme/app_color.dart';
import 'package:uit_buddy_mobile/core/theme/app_text_style.dart';

class PostAuthorHeader extends StatelessWidget {
  const PostAuthorHeader({
    super.key,
    required this.name,
    required this.avatarLetter,
    this.avatarUrl,
  });

  final String name;
  final String avatarLetter;
  final String? avatarUrl;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _buildAvatar(),
        const SizedBox(width: 12),
        Text(
          name,
          style: AppTextStyle.bodyMedium.copyWith(
            fontWeight: AppTextStyle.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildAvatar() {
    if (avatarUrl != null && avatarUrl!.isNotEmpty) {
      return ClipOval(
        child: Image.network(
          avatarUrl!,
          width: 44,
          height: 44,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) => _buildLetterAvatar(),
        ),
      );
    }
    return _buildLetterAvatar();
  }

  Widget _buildLetterAvatar() {
    return Container(
      width: 44,
      height: 44,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        gradient: AppColor.blueAvatarGradient,
      ),
      child: Center(
        child: Text(
          avatarLetter,
          style: const TextStyle(
            color: AppColor.pureWhite,
            fontWeight: FontWeight.w600,
            fontSize: 18,
          ),
        ),
      ),
    );
  }
}

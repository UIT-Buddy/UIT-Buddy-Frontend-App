import 'package:flutter/material.dart';
import 'package:uit_buddy_mobile/core/theme/app_color.dart';
import 'package:uit_buddy_mobile/core/theme/app_text_style.dart';

class PostAuthorHeader extends StatelessWidget {
  const PostAuthorHeader({
    super.key,
    required this.name,
    required this.avatarLetter,
  });

  final String name;
  final String avatarLetter;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
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
        ),
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
}

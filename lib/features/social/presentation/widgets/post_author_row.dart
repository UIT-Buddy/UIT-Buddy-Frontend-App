import 'package:flutter/material.dart';
import 'package:uit_buddy_mobile/core/theme/app_color.dart';
import 'package:uit_buddy_mobile/core/theme/app_text_style.dart';

class PostAuthorRow extends StatelessWidget {
  final String authorName;
  final String authorClass;
  final String? authorAvatarUrl;
  final String timeAgo;

  const PostAuthorRow({
    super.key,
    required this.authorName,
    required this.authorClass,
    this.authorAvatarUrl,
    required this.timeAgo,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        children: [
          _buildAvatar(),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  authorName,
                  style: AppTextStyle.bodySmall.copyWith(
                    fontWeight: AppTextStyle.bold,
                  ),
                ),
                const SizedBox(height: 2),
                Row(
                  children: [
                    Text(authorClass, style: AppTextStyle.captionMedium),
                    const SizedBox(width: 6),
                    Container(
                      width: 3,
                      height: 3,
                      decoration: const BoxDecoration(
                        color: AppColor.secondaryText,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(timeAgo, style: AppTextStyle.captionMedium),
                  ],
                ),
              ],
            ),
          ),
          const Icon(Icons.more_horiz, color: AppColor.secondaryText, size: 20),
        ],
      ),
    );
  }

  Widget _buildAvatar() {
    if (authorAvatarUrl != null && authorAvatarUrl!.isNotEmpty) {
      return CircleAvatar(
        radius: 20,
        backgroundColor: AppColor.veryLightGrey,
        backgroundImage: NetworkImage(authorAvatarUrl!),
      );
    }

    return CircleAvatar(
      radius: 20,
      backgroundColor: AppColor.primaryBlue20,
      child: Text(
        authorName.isNotEmpty ? authorName[0].toUpperCase() : '?',
        style: AppTextStyle.bodySmall.copyWith(
          color: AppColor.primaryBlue,
          fontWeight: AppTextStyle.bold,
        ),
      ),
    );
  }
}

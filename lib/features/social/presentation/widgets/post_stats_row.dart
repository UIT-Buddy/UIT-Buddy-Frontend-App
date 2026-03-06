import 'package:flutter/material.dart';
import 'package:uit_buddy_mobile/core/theme/app_color.dart';
import 'package:uit_buddy_mobile/core/theme/app_text_style.dart';
import 'package:uit_buddy_mobile/features/social/presentation/constants/social_text.dart';

class PostStatsRow extends StatelessWidget {
  final int likeCount;
  final int commentCount;
  final int shareCount;

  const PostStatsRow({
    super.key,
    required this.likeCount,
    required this.commentCount,
    required this.shareCount,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          Text(
            SocialText.likesCount(likeCount),
            style: AppTextStyle.captionMedium.copyWith(
              color: AppColor.secondaryText,
            ),
          ),
          const SizedBox(width: 16),
          Text(
            SocialText.commentsCount(commentCount),
            style: AppTextStyle.captionMedium.copyWith(
              color: AppColor.secondaryText,
            ),
          ),
          const SizedBox(width: 16),
          Text(
            SocialText.sharesCount(shareCount),
            style: AppTextStyle.captionMedium.copyWith(
              color: AppColor.secondaryText,
            ),
          ),
        ],
      ),
    );
  }
}

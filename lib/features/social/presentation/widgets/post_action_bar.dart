import 'package:flutter/material.dart';
import 'package:uit_buddy_mobile/core/theme/app_color.dart';
import 'package:uit_buddy_mobile/core/theme/app_text_style.dart';
import 'package:uit_buddy_mobile/features/social/presentation/constants/social_text.dart';

class PostActionBar extends StatelessWidget {
  final bool isLiked;
  final VoidCallback onLikeTap;
  final VoidCallback? onCommentTap;
  final VoidCallback? onShareTap;

  const PostActionBar({
    super.key,
    required this.isLiked,
    required this.onLikeTap,
    this.onCommentTap,
    this.onShareTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 4),
      decoration: const BoxDecoration(
        border: Border(
          top: BorderSide(color: AppColor.dividerGrey, width: 0.5),
        ),
      ),
      child: Row(
        children: [
          _buildActionButton(
            icon: isLiked ? Icons.favorite : Icons.favorite_border,
            label: SocialText.like,
            color: isLiked ? AppColor.alertRed : AppColor.secondaryText,
            onTap: onLikeTap,
          ),
          _buildActionButton(
            icon: Icons.chat_bubble_outline,
            label: SocialText.comment,
            color: AppColor.secondaryText,
            onTap: onCommentTap,
          ),
          _buildActionButton(
            icon: Icons.share_outlined,
            label: SocialText.share,
            color: AppColor.secondaryText,
            onTap: onShareTap,
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required Color color,
    VoidCallback? onTap,
  }) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 20, color: color),
              const SizedBox(width: 6),
              Text(
                label,
                style: AppTextStyle.captionLarge.copyWith(color: color),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

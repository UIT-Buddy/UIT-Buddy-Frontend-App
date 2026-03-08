import 'package:flutter/material.dart';
import 'package:uit_buddy_mobile/core/theme/app_color.dart';
import 'package:uit_buddy_mobile/core/theme/app_text_style.dart';
import 'package:uit_buddy_mobile/features/social/domain/entities/post_entity.dart';
import 'package:uit_buddy_mobile/features/social/presentation/widgets/post_action_bar.dart';
import 'package:uit_buddy_mobile/features/social/presentation/widgets/post_author_row.dart';
import 'package:uit_buddy_mobile/features/social/presentation/widgets/post_stats_row.dart';

class PostCard extends StatelessWidget {
  final PostEntity post;
  final VoidCallback onLikeTap;

  const PostCard({super.key, required this.post, required this.onLikeTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(color: AppColor.dividerGrey, width: 6),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          PostAuthorRow(
            authorName: post.authorName,
            authorClass: post.authorClass,
            authorAvatarUrl: post.authorAvatarUrl,
            timeAgo: post.timeAgo,
          ),
          _buildContent(),
          if (post.imageUrl != null) _buildImage(),
          PostStatsRow(
            likeCount: post.likeCount,
            commentCount: post.commentCount,
            shareCount: post.shareCount,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: PostActionBar(isLiked: post.isLiked, onLikeTap: onLikeTap),
          ),
          const SizedBox(height: 4),
        ],
      ),
    );
  }

  Widget _buildContent() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Text(
        post.content,
        style: AppTextStyle.bodySmall.copyWith(height: 1.5),
      ),
    );
  }

  Widget _buildImage() {
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: AspectRatio(
        aspectRatio: 16 / 10,
        child: Image.network(
          post.imageUrl!,
          fit: BoxFit.cover,
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) return child;
            return Container(
              color: AppColor.veryLightGrey,
              child: const Center(
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: AppColor.primaryBlue,
                ),
              ),
            );
          },
          errorBuilder: (context, error, stackTrace) {
            return Container(
              color: AppColor.veryLightGrey,
              child: const Center(
                child: Icon(
                  Icons.image_not_supported_outlined,
                  color: AppColor.secondaryText,
                  size: 40,
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

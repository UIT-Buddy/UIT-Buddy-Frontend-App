import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:uit_buddy_mobile/core/utils/datetime.dart';
import 'package:uit_buddy_mobile/core/theme/app_color.dart';
import 'package:uit_buddy_mobile/core/theme/app_text_style.dart';
import 'package:uit_buddy_mobile/features/social/domain/entities/post_entity.dart';
import 'package:uit_buddy_mobile/features/social/domain/entities/post_media_entity.dart';
import 'package:uit_buddy_mobile/features/social/presentation/widgets/post_action_bar.dart';
import 'package:uit_buddy_mobile/features/social/presentation/widgets/post_author_row.dart';
import 'package:uit_buddy_mobile/features/social/presentation/widgets/post_stats_row.dart';
import 'package:uit_buddy_mobile/features/social/presentation/widgets/posts/post_network_video_tile.dart';

class PostCard extends StatelessWidget {
  final PostEntity post;
  final VoidCallback onLikeTap;
  final VoidCallback? onDeleteTap;
  final VoidCallback? onEditTap;
  final VoidCallback? onCommentTap;
  final VoidCallback? onTap;
  final String? currentUserMssv;

  const PostCard({
    super.key,
    required this.post,
    required this.onLikeTap,
    this.onDeleteTap,
    this.onEditTap,
    this.onCommentTap,
    this.onTap,
    this.currentUserMssv,
  });

  @override
  Widget build(BuildContext context) {
    final isAuthor =
        currentUserMssv != null && currentUserMssv == post.authorMssv;

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.deferToChild,
      child: Container(
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
            timeAgo: DateTimeUtils.getTimeAgo(post.createdAt),
            isAuthor: isAuthor,
            postContent: post.contentSnippet,
            onDeleteConfirmed: onDeleteTap,
            onEditTap: onEditTap,
          ),
          if (post.title.isNotEmpty) _buildTitle(),
          _buildContent(),
          if (post.medias.isNotEmpty) _buildMediaGrid(),
          PostStatsRow(
            likeCount: post.likeCount,
            commentCount: post.commentCount,
            shareCount: post.shareCount,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: PostActionBar(
              isLiked: post.isLiked,
              onLikeTap: onLikeTap,
              onCommentTap: onCommentTap,
            ),
          ),
          const SizedBox(height: 4),
        ],
      ),
    ),
    );
  }

  Widget _buildTitle() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 0),
      child: Text(
        post.title,
        style: AppTextStyle.bodySmall.copyWith(
          fontWeight: AppTextStyle.bold,
          height: 1.4,
        ),
      ),
    );
  }

  Widget _buildContent() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: Text(
        post.contentSnippet,
        style: AppTextStyle.bodySmall.copyWith(height: 1.5),
      ),
    );
  }

  Widget _buildMediaGrid() {
    final medias = post.medias;
    final count = medias.length;

    if (count == 1) {
      return Padding(
        padding: const EdgeInsets.only(top: 4),
        child: AspectRatio(
          aspectRatio: 16 / 10,
          child: _MediaTile(media: medias[0]),
        ),
      );
    }

    if (count == 2) {
      return Padding(
        padding: const EdgeInsets.only(top: 4),
        child: SizedBox(
          height: 220,
          child: Row(
            children: [
              Expanded(child: _MediaTile(media: medias[0])),
              const SizedBox(width: 2),
              Expanded(child: _MediaTile(media: medias[1])),
            ],
          ),
        ),
      );
    }

    if (count == 3) {
      return Padding(
        padding: const EdgeInsets.only(top: 4),
        child: SizedBox(
          height: 240,
          child: Row(
            children: [
              Expanded(
                flex: 2,
                child: _MediaTile(media: medias[0]),
              ),
              const SizedBox(width: 2),
              Expanded(
                child: Column(
                  children: [
                    Expanded(child: _MediaTile(media: medias[1])),
                    const SizedBox(height: 2),
                    Expanded(child: _MediaTile(media: medias[2])),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    }

    // 4+ media: 2x2 grid with overflow indicator on last tile
    final visibleMedias = medias.take(4).toList();
    final overflow = count - 4;

    return Padding(
      padding: const EdgeInsets.only(top: 4),
      child: SizedBox(
        height: 240,
        child: Column(
          children: [
            Expanded(
              child: Row(
                children: [
                  Expanded(child: _MediaTile(media: visibleMedias[0])),
                  const SizedBox(width: 2),
                  Expanded(child: _MediaTile(media: visibleMedias[1])),
                ],
              ),
            ),
            const SizedBox(height: 2),
            Expanded(
              child: Row(
                children: [
                  Expanded(child: _MediaTile(media: visibleMedias[2])),
                  const SizedBox(width: 2),
                  Expanded(
                    child: _MediaTile(
                      media: visibleMedias[3],
                      overflowCount: overflow > 0 ? overflow : null,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MediaTile extends StatelessWidget {
  final PostMediaEntity media;
  final int? overflowCount;

  const _MediaTile({required this.media, this.overflowCount});

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        _buildMedia(),
        if (overflowCount != null && overflowCount! > 0) _buildOverlay(),
      ],
    );
  }

  Widget _buildMedia() {
    if (media.type == PostMediaType.video) {
      return PostNetworkVideoTile(url: media.url);
    }

    return Image.network(
      media.url,
      fit: BoxFit.cover,
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) return child;
        return Shimmer.fromColors(
          baseColor: AppColor.dividerGrey,
          highlightColor: AppColor.veryLightGrey,
          child: Container(color: Colors.white),
        );
      },
      errorBuilder: (context, error, stackTrace) {
        return Container(
          color: AppColor.veryLightGrey,
          child: const Center(
            child: Icon(
              Icons.image_not_supported_outlined,
              color: AppColor.secondaryText,
              size: 32,
            ),
          ),
        );
      },
    );
  }

  Widget _buildOverlay() {
    return Container(
      color: Colors.black54,
      child: Center(
        child: Text(
          '+$overflowCount',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

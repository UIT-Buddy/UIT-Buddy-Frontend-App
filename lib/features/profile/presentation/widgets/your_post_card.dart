import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:uit_buddy_mobile/core/theme/app_color.dart';
import 'package:uit_buddy_mobile/core/theme/app_text_style.dart';
import 'package:uit_buddy_mobile/core/utils/datetime.dart';
import 'package:uit_buddy_mobile/features/profile/domain/entities/post_entity.dart';
import 'package:uit_buddy_mobile/features/profile/presentation/widgets/posts/media_viewer_screen.dart';
import 'package:uit_buddy_mobile/features/profile/presentation/widgets/posts/profile_network_video_tile.dart';

class YourPostCard extends StatelessWidget {
  final PostEntity post;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final VoidCallback onLikeTap;
  final VoidCallback? onCommentTap;
  final VoidCallback? onTap;

  const YourPostCard({
    super.key,
    required this.post,
    required this.onEdit,
    required this.onDelete,
    required this.onLikeTap,
    this.onCommentTap,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
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
            _buildAuthorRow(context),
            // Title
            if (post.title.isNotEmpty)
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 4, 16, 0),
                child: Text(
                  post.title,
                  style: AppTextStyle.bodySmall.copyWith(
                    fontWeight: AppTextStyle.bold,
                    height: 1.4,
                  ),
                ),
              ),
            // Content
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              child: Text(
                post.content,
                style: AppTextStyle.bodySmall.copyWith(height: 1.5),
              ),
            ),
            // Media (gallery if any)
            if (post.medias.isNotEmpty) _buildMediaGrid(context),
            // Stats
            _buildStatsRow(),
            // Action bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: _buildActionBar(),
            ),
            const SizedBox(height: 4),
          ],
        ),
      ),
    );
  }

  Widget _buildAuthorRow(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        children: [
          CircleAvatar(
            radius: 20,
            backgroundColor: AppColor.veryLightGrey,
            backgroundImage: _resolveImage(post.author.avatarUrl),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  post.author.fullName,
                  style: AppTextStyle.bodySmall.copyWith(
                    fontWeight: AppTextStyle.bold,
                  ),
                ),
                const SizedBox(height: 2),
                Row(
                  children: [
                    Text(
                      post.author.homeClassCode,
                      style: AppTextStyle.captionMedium,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '• ${DateTimeUtils.getTimeAgo(post.createdAt)}',
                      style: AppTextStyle.captionMedium.copyWith(
                        color: AppColor.secondaryText,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          // Three-dot menu
          PopupMenuButton<_PostMenuAction>(
            icon: const Icon(
              Icons.more_horiz,
              color: AppColor.secondaryText,
              size: 20,
            ),
            padding: EdgeInsets.zero,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            onSelected: (action) {
              if (action == _PostMenuAction.edit) {
                onEdit();
              } else {
                onDelete();
              }
            },
            itemBuilder: (_) => [
              PopupMenuItem(
                value: _PostMenuAction.edit,
                child: Row(
                  children: [
                    const Icon(
                      Icons.edit_outlined,
                      size: 18,
                      color: AppColor.primaryText,
                    ),
                    const SizedBox(width: 10),
                    Text('Edit', style: AppTextStyle.bodySmall),
                  ],
                ),
              ),
              PopupMenuItem(
                value: _PostMenuAction.delete,
                child: Row(
                  children: [
                    const Icon(
                      Icons.delete_outline,
                      size: 18,
                      color: AppColor.alertRed,
                    ),
                    const SizedBox(width: 10),
                    Text(
                      'Delete',
                      style: AppTextStyle.bodySmall.copyWith(
                        color: AppColor.alertRed,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatsRow() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          Text(
            '${post.likeCount} likes',
            style: AppTextStyle.captionMedium.copyWith(
              color: AppColor.secondaryText,
            ),
          ),
          const SizedBox(width: 16),
          Text(
            '${post.commentCount} comments',
            style: AppTextStyle.captionMedium.copyWith(
              color: AppColor.secondaryText,
            ),
          ),
          const SizedBox(width: 16),
          Text(
            '${post.shareCount} shares',
            style: AppTextStyle.captionMedium.copyWith(
              color: AppColor.secondaryText,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionBar() {
    final likeIconColor = post.isLiked
        ? AppColor.alertRed
        : AppColor.secondaryText;
    final likeIcon = post.isLiked ? Icons.favorite : Icons.favorite_border;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 4),
      decoration: const BoxDecoration(
        border: Border(
          top: BorderSide(color: AppColor.dividerGrey, width: 0.5),
        ),
      ),
      child: Row(
        children: [
          _actionButton(likeIcon, 'Like', likeIconColor, onLikeTap),
          _actionButton(
            Icons.chat_bubble_outline,
            'Comment',
            AppColor.secondaryText,
            onCommentTap,
          ),
          _actionButton(
            Icons.share_outlined,
            'Share',
            AppColor.secondaryText,
            null,
          ),
        ],
      ),
    );
  }

  Widget _actionButton(
    IconData icon,
    String label,
    Color color,
    VoidCallback? onTap,
  ) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
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

  ImageProvider _resolveImage(String url) {
    if (url.startsWith('http')) return NetworkImage(url);
    return AssetImage(url);
  }

  Widget _buildMediaGrid(BuildContext context) {
    final medias = post.medias;
    final count = medias.length;

    // Helper to build a tile with shared post/callback context
    _MediaTile tile(MediaEntity m, int i, {int? overflow}) => _MediaTile(
      media: m,
      allMedias: medias,
      index: i,
      post: post,
      onLikeTap: onLikeTap,
      onCommentTap: onCommentTap,
      overflowCount: overflow,
    );

    if (count == 1) {
      return Padding(
        padding: const EdgeInsets.only(top: 4),
        child: AspectRatio(aspectRatio: 16 / 10, child: tile(medias[0], 0)),
      );
    }

    if (count == 2) {
      return Padding(
        padding: const EdgeInsets.only(top: 4),
        child: SizedBox(
          height: 220,
          child: Row(
            children: [
              Expanded(child: tile(medias[0], 0)),
              const SizedBox(width: 2),
              Expanded(child: tile(medias[1], 1)),
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
              Expanded(flex: 2, child: tile(medias[0], 0)),
              const SizedBox(width: 2),
              Expanded(
                child: Column(
                  children: [
                    Expanded(child: tile(medias[1], 1)),
                    const SizedBox(height: 2),
                    Expanded(child: tile(medias[2], 2)),
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
                  Expanded(child: tile(visibleMedias[0], 0)),
                  const SizedBox(width: 2),
                  Expanded(child: tile(visibleMedias[1], 1)),
                ],
              ),
            ),
            const SizedBox(height: 2),
            Expanded(
              child: Row(
                children: [
                  Expanded(child: tile(visibleMedias[2], 2)),
                  const SizedBox(width: 2),
                  Expanded(
                    child: tile(
                      visibleMedias[3],
                      3,
                      overflow: overflow > 0 ? overflow : null,
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
  final MediaEntity media;
  final List<MediaEntity> allMedias;
  final int index;
  final PostEntity post;
  final VoidCallback onLikeTap;
  final VoidCallback? onCommentTap;
  final int? overflowCount;

  const _MediaTile({
    required this.media,
    required this.allMedias,
    required this.index,
    required this.post,
    required this.onLikeTap,
    this.onCommentTap,
    this.overflowCount,
  });

  void _openViewer(BuildContext context) {
    Navigator.of(context).push(
      ProfileMediaViewerScreen.route(
        medias: allMedias,
        initialIndex: index,
        post: post,
        onLikeTap: onLikeTap,
        onCommentTap: onCommentTap,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _openViewer(context),
      child: Stack(
        fit: StackFit.expand,
        children: [
          _buildMedia(context),
          if (overflowCount != null && overflowCount! > 0) _buildOverlay(),
        ],
      ),
    );
  }

  Widget _buildMedia(BuildContext context) {
    if (media.type == MediaType.video) {
      return ProfileNetworkVideoTile(
        url: media.url,
        onTap: () => _openViewer(context),
      );
    }

    return CachedNetworkImage(
      imageUrl: media.url,
      fit: BoxFit.cover,
      placeholder: (context, url) => Shimmer.fromColors(
        baseColor: AppColor.dividerGrey,
        highlightColor: AppColor.veryLightGrey,
        child: Container(color: Colors.white),
      ),
      errorWidget: (context, url, error) => Container(
        color: AppColor.veryLightGrey,
        child: const Center(
          child: Icon(
            Icons.image_not_supported_outlined,
            color: AppColor.secondaryText,
            size: 32,
          ),
        ),
      ),
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

enum _PostMenuAction { edit, delete }

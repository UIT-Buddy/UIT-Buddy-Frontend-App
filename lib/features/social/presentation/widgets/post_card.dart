import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:uit_buddy_mobile/core/utils/datetime.dart';
import 'package:uit_buddy_mobile/core/theme/app_color.dart';
import 'package:uit_buddy_mobile/core/theme/app_text_style.dart';
import 'package:uit_buddy_mobile/features/social/domain/entities/post_entity.dart';
import 'package:uit_buddy_mobile/features/social/domain/entities/post_media_entity.dart';
import 'package:uit_buddy_mobile/features/social/presentation/screens/user_profile_screen.dart';
import 'package:uit_buddy_mobile/features/social/presentation/widgets/post_action_bar.dart';
import 'package:uit_buddy_mobile/features/social/presentation/widgets/post_author_row.dart';
import 'package:uit_buddy_mobile/features/social/presentation/widgets/post_stats_row.dart';
import 'package:uit_buddy_mobile/features/social/presentation/widgets/posts/media_viewer_screen.dart';
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
              onViewProfile: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => UserProfileScreen(mssv: post.authorMssv),
                  ),
                );
              },
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

    // Helper to build a tile with shared post/callback context
    _MediaTile tile(PostMediaEntity m, int i, {int? overflow}) => _MediaTile(
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
  final PostMediaEntity media;
  final List<PostMediaEntity> allMedias;
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
      MediaViewerScreen.route(
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
    if (media.type == PostMediaType.video) {
      return PostNetworkVideoTile(
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

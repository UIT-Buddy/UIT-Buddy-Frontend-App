import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uit_buddy_mobile/app/di/app_dependencies.dart';
import 'package:uit_buddy_mobile/core/theme/app_color.dart';
import 'package:uit_buddy_mobile/core/theme/app_text_style.dart';
import 'package:uit_buddy_mobile/features/profile/domain/entities/post_entity.dart';
import 'package:uit_buddy_mobile/features/profile/presentation/bloc/your_posts_screen/your_posts_bloc.dart';
import 'package:uit_buddy_mobile/features/profile/presentation/bloc/your_posts_screen/your_posts_event.dart';
import 'package:uit_buddy_mobile/features/profile/presentation/bloc/your_posts_screen/your_posts_state.dart';

class YourPostsScreen extends StatelessWidget {
  const YourPostsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          serviceLocator<YourPostsBloc>()..add(const YourPostsLoaded()),
      child: const _YourPostsBody(),
    );
  }
}

// ── Body ─────────────────────────────────────────────────────────────────────

class _YourPostsBody extends StatefulWidget {
  const _YourPostsBody();

  @override
  State<_YourPostsBody> createState() => _YourPostsBodyState();
}

class _YourPostsBodyState extends State<_YourPostsBody> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      context.read<YourPostsBloc>().add(
            YourPostsSearchChanged(query: _searchController.text),
          );
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onEdit(PostEntity post) {
    // TODO: navigate to edit-post screen
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Edit post ${post.id}'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _onDelete(PostEntity post) {
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Post'),
        content: const Text('Are you sure you want to delete this post?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              context
                  .read<YourPostsBloc>()
                  .add(YourPostsPostDeleted(postId: post.id));
            },
            style: TextButton.styleFrom(foregroundColor: AppColor.alertRed),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.pureWhite,
      body: SafeArea(
        child: Column(
          children: [
            // ── Header ───────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(
                      Icons.arrow_back,
                      color: AppColor.primaryText,
                    ),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                  Expanded(
                    child: Text(
                      'Your Posts',
                      textAlign: TextAlign.center,
                      style: AppTextStyle.h3.copyWith(
                        fontWeight: AppTextStyle.bold,
                      ),
                    ),
                  ),
                  const SizedBox(width: 48),
                ],
              ),
            ),

            const Divider(height: 1, color: AppColor.dividerGrey),

            // ── Search Bar ───────────────────────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              child: Container(
                height: 44,
                decoration: BoxDecoration(
                  color: AppColor.veryLightGrey,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    const SizedBox(width: 12),
                    const Icon(
                      Icons.search,
                      color: AppColor.secondaryText,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: TextField(
                        controller: _searchController,
                        style: AppTextStyle.bodySmall,
                        decoration: InputDecoration(
                          hintText: 'Search by name...',
                          hintStyle: AppTextStyle.bodySmall.copyWith(
                            color: AppColor.secondaryText,
                          ),
                          border: InputBorder.none,
                          isDense: true,
                          contentPadding: EdgeInsets.zero,
                        ),
                      ),
                    ),
                    BlocBuilder<YourPostsBloc, YourPostsState>(
                      builder: (context, state) {
                        return state.searchQuery.isNotEmpty
                            ? GestureDetector(
                                onTap: () => _searchController.clear(),
                                child: const Padding(
                                  padding: EdgeInsets.all(8),
                                  child: Icon(
                                    Icons.close,
                                    size: 16,
                                    color: AppColor.secondaryText,
                                  ),
                                ),
                              )
                            : const Padding(
                                padding: EdgeInsets.only(right: 12),
                                child: Icon(
                                  Icons.tune,
                                  size: 20,
                                  color: AppColor.secondaryText,
                                ),
                              );
                      },
                    ),
                  ],
                ),
              ),
            ),

            // ── Content ──────────────────────────────────────────
            Expanded(
              child: BlocBuilder<YourPostsBloc, YourPostsState>(
                builder: (context, state) {
                  if (state.status == YourPostsStatus.loading) {
                    return const Center(
                      child: CircularProgressIndicator(
                        color: AppColor.primaryBlue,
                      ),
                    );
                  }

                  if (state.status == YourPostsStatus.error) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.error_outline,
                            color: AppColor.alertRed,
                            size: 48,
                          ),
                          const SizedBox(height: 12),
                          Text(
                            state.errorMessage ?? 'Something went wrong.',
                            style: AppTextStyle.bodyMedium,
                          ),
                        ],
                      ),
                    );
                  }

                  if (state.filtered.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.article_outlined,
                            size: 48,
                            color: AppColor.tertiaryText,
                          ),
                          const SizedBox(height: 12),
                          Text(
                            'No posts found',
                            style: AppTextStyle.bodyMedium.copyWith(
                              color: AppColor.secondaryText,
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  return ListView.builder(
                    padding: EdgeInsets.zero,
                    itemCount: state.filtered.length,
                    itemBuilder: (context, index) {
                      final post = state.filtered[index];
                      return _YourPostCard(
                        post: post,
                        onEdit: () => _onEdit(post),
                        onDelete: () => _onDelete(post),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── _YourPostCard ─────────────────────────────────────────────────────────────

class _YourPostCard extends StatelessWidget {
  final PostEntity post;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _YourPostCard({
    required this.post,
    required this.onEdit,
    required this.onDelete,
  });

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
          _buildAuthorRow(context),
          // Content
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            child: Text(
              post.content,
              style: AppTextStyle.bodySmall.copyWith(height: 1.5),
            ),
          ),
          // Media (gallery if any)
          if (post.mediaUrls.isNotEmpty) _PostMediaGallery(urls: post.mediaUrls),
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
            backgroundImage: _resolveImage(post.user.avatarUrl),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  post.user.name,
                  style: AppTextStyle.bodySmall.copyWith(
                    fontWeight: AppTextStyle.bold,
                  ),
                ),
                const SizedBox(height: 2),
                Text(post.user.homeClass, style: AppTextStyle.captionMedium),
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
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 4),
      decoration: const BoxDecoration(
        border: Border(
          top: BorderSide(color: AppColor.dividerGrey, width: 0.5),
        ),
      ),
      child: Row(
        children: [
          _actionButton(Icons.favorite_border, 'Like', AppColor.secondaryText),
          _actionButton(
              Icons.chat_bubble_outline, 'Comment', AppColor.secondaryText),
          _actionButton(Icons.share_outlined, 'Share', AppColor.secondaryText),
        ],
      ),
    );
  }

  Widget _actionButton(IconData icon, String label, Color color) {
    return Expanded(
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
    );
  }

  ImageProvider _resolveImage(String url) {
    if (url.startsWith('http')) return NetworkImage(url);
    return AssetImage(url);
  }
}

class _PostMediaGallery extends StatefulWidget {
  final List<String> urls;
  const _PostMediaGallery({required this.urls});

  @override
  State<_PostMediaGallery> createState() => _PostMediaGalleryState();
}

class _PostMediaGalleryState extends State<_PostMediaGallery> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    if (widget.urls.isEmpty) return const SizedBox.shrink();
    if (widget.urls.length == 1) {
      return Padding(
        padding: const EdgeInsets.only(top: 8),
        child: _PostMediaItem(url: widget.urls.first),
      );
    }

    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Stack(
        children: [
          AspectRatio(
            aspectRatio: 16 / 10,
            child: PageView.builder(
              itemCount: widget.urls.length,
              onPageChanged: (index) {
                setState(() => _currentIndex = index);
              },
              itemBuilder: (context, index) {
                return _PostMediaItem(url: widget.urls[index]);
              },
            ),
          ),
          Positioned(
            top: 12,
            right: 12,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.6),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Text(
                '${_currentIndex + 1}/${widget.urls.length}',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PostMediaItem extends StatelessWidget {
  final String url;
  const _PostMediaItem({required this.url});

  @override
  Widget build(BuildContext context) {
    final isAsset = !url.startsWith('http');
    return AspectRatio(
      aspectRatio: 16 / 10,
      child: isAsset
          ? Image.asset(
              url,
              fit: BoxFit.cover,
              errorBuilder: (_, _, _) => _imagePlaceholder(),
            )
          : Image.network(
              url,
              fit: BoxFit.cover,
              loadingBuilder: (context, child, progress) {
                if (progress == null) return child;
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
              errorBuilder: (_, _, _) => _imagePlaceholder(),
            ),
    );
  }

  Widget _imagePlaceholder() {
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
  }
}

enum _PostMenuAction { edit, delete }

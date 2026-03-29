import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uit_buddy_mobile/core/theme/app_color.dart';
import 'package:uit_buddy_mobile/core/theme/app_text_style.dart';
import 'package:uit_buddy_mobile/features/profile/domain/entities/post_entity.dart';
import 'package:uit_buddy_mobile/features/profile/presentation/bloc/your_posts_screen/your_posts_bloc.dart';
import 'package:uit_buddy_mobile/features/profile/presentation/bloc/your_posts_screen/your_posts_event.dart';
import 'package:uit_buddy_mobile/features/profile/presentation/bloc/your_posts_screen/your_posts_state.dart';
import 'package:uit_buddy_mobile/features/profile/presentation/widgets/your_post_card.dart';
import 'package:uit_buddy_mobile/features/profile/presentation/widgets/post_card_skeleton.dart';
import 'package:uit_buddy_mobile/features/social/presentation/screens/edit_post_screen.dart';
import 'package:uit_buddy_mobile/features/social/presentation/screens/post_detail_screen.dart';
import 'package:uit_buddy_mobile/features/social/domain/entities/post_entity.dart'
    as social;
import 'package:uit_buddy_mobile/features/social/domain/entities/post_media_entity.dart';

class YourPostsList extends StatefulWidget {
  const YourPostsList({super.key});

  @override
  State<YourPostsList> createState() => _YourPostsListState();
}

class _YourPostsListState extends State<YourPostsList> {
  late final ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_onScroll)
      ..dispose();
    super.dispose();
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;
    final position = _scrollController.position;
    if (position.pixels >= position.maxScrollExtent - 200) {
      context.read<YourPostsBloc>().add(const YourPostsLoadMore());
    }
  }

  Future<void> _onEdit(PostEntity post) async {
    final socialPost = post.toSocialPost();
    await Navigator.of(context).push<social.PostEntity>(
      MaterialPageRoute(builder: (_) => EditPostScreen(post: socialPost)),
    );
    // Note: In a real app, you'd handle the updated post returned from the edit screen
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
              context.read<YourPostsBloc>().add(
                YourPostsPostDeleted(postId: post.id),
              );
            },
            style: TextButton.styleFrom(foregroundColor: AppColor.alertRed),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _openPostDetail(PostEntity post) {
    final socialPost = post.toSocialPost();
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) =>
            PostDetailScreen(postId: post.id, initialPost: socialPost),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<YourPostsBloc, YourPostsState>(
      builder: (context, state) {
        if (state.status == YourPostsStatus.loading) {
          return ListView.builder(
            padding: EdgeInsets.zero,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: 5,
            itemBuilder: (_, index) => PostCardSkeleton(showImage: index == 1),
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
                const SizedBox(height: 16),
                TextButton(
                  onPressed: () => context.read<YourPostsBloc>().add(
                    const YourPostsRefreshed(),
                  ),
                  child: const Text('Thử lại'),
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

        final itemCount =
            state.filtered.length +
            (state.hasMore || state.isLoadingMore ? 1 : 0);

        return RefreshIndicator(
          color: AppColor.primaryBlue,
          onRefresh: () async {
            context.read<YourPostsBloc>().add(const YourPostsRefreshed());
            await context.read<YourPostsBloc>().stream.firstWhere(
              (s) => s.status != YourPostsStatus.loading,
            );
          },
          child: ListView.builder(
            controller: _scrollController,
            padding: EdgeInsets.zero,
            cacheExtent: 800,
            itemCount: itemCount,
            itemBuilder: (context, index) {
              // Bottom loader slot
              if (index == state.filtered.length) {
                return _buildBottomLoader(state);
              }

              final post = state.filtered[index];
              return YourPostCard(
                key: ValueKey(post.id),
                post: post,
                onEdit: () => _onEdit(post),
                onDelete: () => _onDelete(post),
                onLikeTap: () => context.read<YourPostsBloc>().add(
                  YourPostsPostLiked(postId: post.id),
                ),
                onCommentTap: () => _openPostDetail(post),
                onTap: () => _openPostDetail(post),
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildBottomLoader(YourPostsState state) {
    if (state.isLoadingMore) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 20),
        child: Center(
          child: CircularProgressIndicator(
            strokeWidth: 2.5,
            color: AppColor.primaryBlue,
          ),
        ),
      );
    }
    return const SizedBox.shrink();
  }
}

extension ProfilePostToSocialPost on PostEntity {
  social.PostEntity toSocialPost() {
    return social.PostEntity(
      id: id,
      title: title,
      authorMssv: author.mssv,
      authorName: author.fullName,
      authorClass: author.homeClassCode,
      authorAvatarUrl: author.avatarUrl.startsWith('http')
          ? author.avatarUrl
          : null,
      contentSnippet: content,
      medias: medias
          .map(
            (m) => PostMediaEntity(
              type: m.type == MediaType.image
                  ? PostMediaType.image
                  : PostMediaType.video,
              url: m.url,
            ),
          )
          .toList(),
      createdAt: createdAt,
      likeCount: likeCount,
      commentCount: commentCount,
      shareCount: shareCount,
      isLiked: isLiked,
    );
  }
}

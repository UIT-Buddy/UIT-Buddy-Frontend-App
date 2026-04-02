import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uit_buddy_mobile/app/di/app_dependencies.dart';
import 'package:uit_buddy_mobile/core/theme/app_color.dart';
import 'package:uit_buddy_mobile/core/theme/app_text_style.dart';
import 'package:uit_buddy_mobile/features/session/presentation/bloc/session_bloc.dart';
import 'package:uit_buddy_mobile/features/social/presentation/bloc/new_feed/new_feed_bloc.dart';
import 'package:uit_buddy_mobile/features/social/presentation/bloc/new_feed/new_feed_event.dart';
import 'package:uit_buddy_mobile/features/social/presentation/bloc/new_feed/new_feed_state.dart';
import 'package:uit_buddy_mobile/features/social/presentation/constants/social_text.dart';
import 'package:uit_buddy_mobile/features/social/presentation/screens/user_search_screen.dart';
import 'package:uit_buddy_mobile/features/social/presentation/widgets/create_post_bar.dart';
import 'package:uit_buddy_mobile/features/social/presentation/widgets/message_tab.dart';
import 'package:uit_buddy_mobile/features/social/presentation/widgets/new_feed_header.dart';
import 'package:uit_buddy_mobile/features/social/presentation/widgets/post_card.dart';
import 'package:uit_buddy_mobile/features/social/domain/entities/post_entity.dart';
import 'package:uit_buddy_mobile/features/social/presentation/screens/edit_post_screen.dart';
import 'package:uit_buddy_mobile/features/social/presentation/screens/post_detail_screen.dart';
import 'package:uit_buddy_mobile/features/social/presentation/screens/social_search_screen.dart';
import 'package:uit_buddy_mobile/features/social/presentation/widgets/post_card_skeleton.dart';

class NewFeedScreen extends StatelessWidget {
  const NewFeedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => serviceLocator<NewFeedBloc>(),
      child: const _NewFeedView(),
    );
  }
}

class _NewFeedView extends StatefulWidget {
  const _NewFeedView();

  @override
  State<_NewFeedView> createState() => _NewFeedViewState();
}

class _NewFeedViewState extends State<_NewFeedView> {
  late final ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_onScroll);
    context.read<NewFeedBloc>().add(const NewFeedStarted());
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
      context.read<NewFeedBloc>().add(const NewFeedLoadMore());
    }
  }

  void _openSearch(BuildContext context, NewFeedTab tab) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => tab == NewFeedTab.feed
            ? const SocialSearchScreen(initialQuery: '')
            : Placeholder(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NewFeedBloc, NewFeedState>(
      // Rebuild for feed state changes too (loading/loaded/posts/load-more),
      // otherwise first fetch won't appear until another UI-triggered rebuild.
      buildWhen: (prev, curr) =>
          prev.selectedTab != curr.selectedTab ||
          prev.status != curr.status ||
          prev.posts != curr.posts ||
          prev.isLoadingMore != curr.isLoadingMore ||
          prev.hasMore != curr.hasMore ||
          prev.errorMessage != curr.errorMessage,
      builder: (context, state) {
        final isMessageTab = state.selectedTab == NewFeedTab.message;
        return Scaffold(
          backgroundColor: AppColor.pureWhite,
          floatingActionButton: isMessageTab
              ? FloatingActionButton(
                  onPressed: () => _openUserSearch(context),
                  backgroundColor: AppColor.primaryBlue,
                  shape: const CircleBorder(),
                  child: const Icon(Icons.edit_outlined, color: Colors.white),
                )
              : null,
          body: SafeArea(
            child: Column(
              children: [
                NewFeedHeader(
                  selectedTabIndex: state.selectedTab == NewFeedTab.feed
                      ? 0
                      : 1,
                  onSearchTap: () => _openSearch(context, state.selectedTab),
                  onTabChanged: (index) {
                    context.read<NewFeedBloc>().add(
                      NewFeedTabChanged(tabIndex: index),
                    );
                  },
                ),
                Expanded(
                  child: IndexedStack(
                    index: state.selectedTab == NewFeedTab.feed ? 0 : 1,
                    children: [
                      _buildFeedTab(context, state),
                      _buildMessageTab(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _openUserSearch(BuildContext context) {
    Navigator.of(context).push(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            const UserSearchScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          final curved = CurvedAnimation(
            parent: animation,
            curve: Curves.easeOutCubic,
            reverseCurve: Curves.easeInCubic,
          );
          return SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0, 1),
              end: Offset.zero,
            ).animate(curved),
            child: child,
          );
        },
        transitionDuration: const Duration(milliseconds: 280),
        reverseTransitionDuration: const Duration(milliseconds: 240),
      ),
    );
  }

  Future<void> _navigateToEdit(BuildContext context, PostEntity post) async {
    final bloc = context.read<NewFeedBloc>();
    final updated = await Navigator.of(context).push<PostEntity>(
      MaterialPageRoute(builder: (_) => EditPostScreen(post: post)),
    );
    if (updated != null) {
      bloc.add(NewFeedPostUpdated(updatedPost: updated));
    }
  }

  Widget _buildFeedTab(BuildContext context, NewFeedState state) {
    if (state.status == NewFeedStatus.loading) {
      return ListView.builder(
        padding: EdgeInsets.zero,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: 5,
        itemBuilder: (_, index) => PostCardSkeleton(showImage: index == 1),
      );
    }

    if (state.status == NewFeedStatus.error) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, color: AppColor.alertRed, size: 48),
            const SizedBox(height: 12),
            Text(
              state.errorMessage ?? SocialText.errorLoading,
              style: AppTextStyle.bodyMedium,
            ),
            const SizedBox(height: 16),
            TextButton(
              onPressed: () =>
                  context.read<NewFeedBloc>().add(const NewFeedRefreshed()),
              child: const Text('Thử lại'),
            ),
          ],
        ),
      );
    }

    // +1 for CreatePostBar, +1 for bottom loader slot when there's more to load
    final itemCount =
        state.posts.length + 1 + (state.hasMore || state.isLoadingMore ? 1 : 0);

    return RefreshIndicator(
      color: AppColor.primaryBlue,
      onRefresh: () async {
        context.read<NewFeedBloc>().add(const NewFeedRefreshed());
        await context.read<NewFeedBloc>().stream.firstWhere(
          (s) => s.status != NewFeedStatus.loading,
        );
      },
      child: ListView.builder(
        controller: _scrollController,
        padding: EdgeInsets.zero,
        cacheExtent: 800,
        itemCount: itemCount,
        itemBuilder: (context, index) {
          if (index == 0) return const CreatePostBar();

          final postIndex = index - 1;

          // Bottom loader slot
          if (postIndex == state.posts.length) {
            return _buildBottomLoader(state);
          }

          final post = state.posts[postIndex];
          final currentMssv = context.read<SessionBloc>().state.user?.mssv;
          return PostCard(
            key: ValueKey(post.id),
            post: post,
            currentUserMssv: currentMssv,
            onLikeTap: () {
              context.read<NewFeedBloc>().add(
                NewFeedPostLiked(postId: post.id),
              );
            },
            onDeleteTap: () {
              context.read<NewFeedBloc>().add(
                NewFeedPostDeleted(postId: post.id),
              );
            },
            onEditTap: () => _navigateToEdit(context, post),
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) =>
                    PostDetailScreen(postId: post.id, initialPost: post),
              ),
            ),
            onCommentTap: () => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) =>
                    PostDetailScreen(postId: post.id, initialPost: post),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildBottomLoader(NewFeedState state) {
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
    // hasMore is true but not currently loading — placeholder while scroll
    // threshold triggers the event
    return const SizedBox.shrink();
  }

  Widget _buildMessageTab() {
    return const MessageTab();
  }
}

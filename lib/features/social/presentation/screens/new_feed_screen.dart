import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uit_buddy_mobile/app/di/app_dependencies.dart';
import 'package:uit_buddy_mobile/core/theme/app_color.dart';
import 'package:uit_buddy_mobile/core/theme/app_text_style.dart';
import 'package:uit_buddy_mobile/features/social/presentation/bloc/new_feed/new_feed_bloc.dart';
import 'package:uit_buddy_mobile/features/social/presentation/bloc/new_feed/new_feed_event.dart';
import 'package:uit_buddy_mobile/features/social/presentation/bloc/new_feed/new_feed_state.dart';
import 'package:uit_buddy_mobile/features/social/presentation/constants/social_text.dart';
import 'package:uit_buddy_mobile/features/social/presentation/widgets/create_post_bar.dart';
import 'package:uit_buddy_mobile/features/social/presentation/widgets/message_tab.dart';
import 'package:uit_buddy_mobile/features/social/presentation/widgets/new_feed_header.dart';
import 'package:uit_buddy_mobile/features/social/presentation/widgets/post_card.dart';
import 'package:uit_buddy_mobile/features/social/presentation/widgets/post_card_skeleton.dart';

class NewFeedScreen extends StatelessWidget {
  const NewFeedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          serviceLocator<NewFeedBloc>()..add(const NewFeedStarted()),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.pureWhite,
      body: SafeArea(
        child: BlocBuilder<NewFeedBloc, NewFeedState>(
          builder: (context, state) {
            return Column(
              children: [
                NewFeedHeader(
                  selectedTabIndex: state.selectedTab == NewFeedTab.feed
                      ? 0
                      : 1,
                  onTabChanged: (index) {
                    context.read<NewFeedBloc>().add(
                      NewFeedTabChanged(tabIndex: index),
                    );
                  },
                ),
                Expanded(
                  child: state.selectedTab == NewFeedTab.feed
                      ? _buildFeedTab(context, state)
                      : _buildMessageTab(),
                ),
              ],
            );
          },
        ),
      ),
    );
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
          return PostCard(
            key: ValueKey(post.id),
            post: post,
            onLikeTap: () {
              context.read<NewFeedBloc>().add(
                NewFeedPostLiked(postId: post.id),
              );
            },
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

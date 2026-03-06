import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
      create: (_) => NewFeedBloc()..add(const NewFeedStarted()),
      child: const _NewFeedView(),
    );
  }
}

class _NewFeedView extends StatelessWidget {
  const _NewFeedView();

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
                  selectedTabIndex:
                      state.selectedTab == NewFeedTab.feed ? 0 : 1,
                  onTabChanged: (index) {
                    context
                        .read<NewFeedBloc>()
                        .add(NewFeedTabChanged(tabIndex: index));
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
            const Icon(
              Icons.error_outline,
              color: AppColor.alertRed,
              size: 48,
            ),
            const SizedBox(height: 12),
            Text(
              state.errorMessage ?? SocialText.errorLoading,
              style: AppTextStyle.bodyMedium,
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      color: AppColor.primaryBlue,
      onRefresh: () async {
        context.read<NewFeedBloc>().add(const NewFeedRefreshed());
        // Wait for the state to change from loading to loaded
        await context.read<NewFeedBloc>().stream.firstWhere(
              (s) => s.status != NewFeedStatus.loading,
            );
      },
      child: ListView.builder(
        padding: EdgeInsets.zero,
        itemCount: state.posts.length + 1, // +1 for CreatePostBar
        itemBuilder: (context, index) {
          if (index == 0) {
            return const CreatePostBar();
          }

          final post = state.posts[index - 1];
          return PostCard(
            post: post,
            onLikeTap: () {
              context
                  .read<NewFeedBloc>()
                  .add(NewFeedPostLiked(postId: post.id));
            },
          );
        },
      ),
    );
  }

  Widget _buildMessageTab() {
    return const MessageTab();
  }
}
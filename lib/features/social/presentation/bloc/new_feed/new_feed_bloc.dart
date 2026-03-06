import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uit_buddy_mobile/features/social/data/mock/mock_posts.dart';
import 'package:uit_buddy_mobile/features/social/presentation/bloc/new_feed/new_feed_event.dart';
import 'package:uit_buddy_mobile/features/social/presentation/bloc/new_feed/new_feed_state.dart';

class NewFeedBloc extends Bloc<NewFeedEvent, NewFeedState> {
  NewFeedBloc() : super(const NewFeedState()) {
    on<NewFeedStarted>(_onNewFeedStarted);
    on<NewFeedTabChanged>(_onTabChanged);
    on<NewFeedPostLiked>(_onPostLiked);
    on<NewFeedRefreshed>(_onRefreshed);
  }

  Future<void> _onNewFeedStarted(
    NewFeedStarted event,
    Emitter<NewFeedState> emit,
  ) async {
    emit(state.copyWith(status: NewFeedStatus.loading));

    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 500));

    emit(state.copyWith(
      status: NewFeedStatus.loaded,
      posts: mockPosts,
    ));
  }

  void _onTabChanged(
    NewFeedTabChanged event,
    Emitter<NewFeedState> emit,
  ) {
    final tab = event.tabIndex == 0 ? NewFeedTab.feed : NewFeedTab.message;
    emit(state.copyWith(selectedTab: tab));
  }

  void _onPostLiked(
    NewFeedPostLiked event,
    Emitter<NewFeedState> emit,
  ) {
    final updatedPosts = state.posts.map((post) {
      if (post.id == event.postId) {
        return post.copyWith(
          isLiked: !post.isLiked,
          likeCount: post.isLiked ? post.likeCount - 1 : post.likeCount + 1,
        );
      }
      return post;
    }).toList();

    emit(state.copyWith(posts: updatedPosts));
  }

  Future<void> _onRefreshed(
    NewFeedRefreshed event,
    Emitter<NewFeedState> emit,
  ) async {
    emit(state.copyWith(status: NewFeedStatus.loading));
    await Future.delayed(const Duration(milliseconds: 500));
    emit(state.copyWith(
      status: NewFeedStatus.loaded,
      posts: mockPosts,
    ));
  }
}

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uit_buddy_mobile/features/social/domain/usecases/create_post_usecase.dart';
import 'package:uit_buddy_mobile/features/social/domain/usecases/delete_post_usecase.dart';
import 'package:uit_buddy_mobile/features/social/domain/usecases/get_newfeed_usecase.dart';
import 'package:uit_buddy_mobile/features/social/domain/usecases/toggle_like_usecase.dart';
import 'package:uit_buddy_mobile/features/social/presentation/bloc/new_feed/new_feed_event.dart';
import 'package:uit_buddy_mobile/features/social/presentation/bloc/new_feed/new_feed_state.dart';

class NewFeedBloc extends Bloc<NewFeedEvent, NewFeedState> {
  NewFeedBloc({
    required GetNewfeedUsecase getNewfeedUsecase,
    required CreatePostUsecase createPostUsecase,
    required DeletePostUsecase deletePostUsecase,
    required ToggleLikeUsecase toggleLikeUsecase,
  }) : _getNewfeedUsecase = getNewfeedUsecase,
       _createPostUsecase = createPostUsecase,
       _deletePostUsecase = deletePostUsecase,
       _toggleLikeUsecase = toggleLikeUsecase,
       super(const NewFeedState()) {
    on<NewFeedStarted>(_onNewFeedStarted);
    on<NewFeedTabChanged>(_onTabChanged);
    on<NewFeedPostLiked>(_onPostLiked);
    on<NewFeedRefreshed>(_onRefreshed);
    on<NewFeedLoadMore>(_onLoadMore);
    on<NewFeedPostSubmitted>(_onPostSubmitted);
    on<NewFeedPostDeleted>(_onPostDeleted);
    on<NewFeedPostUpdated>(_onPostUpdated);
  }

  final GetNewfeedUsecase _getNewfeedUsecase;
  final CreatePostUsecase _createPostUsecase;
  final DeletePostUsecase _deletePostUsecase;
  final ToggleLikeUsecase _toggleLikeUsecase;

  Future<void> _onNewFeedStarted(
    NewFeedStarted event,
    Emitter<NewFeedState> emit,
  ) async {
    emit(state.copyWith(status: NewFeedStatus.loading));
    final result = await _getNewfeedUsecase(const GetNewfeedParams());
    result.fold(
      (failure) => emit(
        state.copyWith(
          status: NewFeedStatus.error,
          errorMessage: failure.message,
        ),
      ),
      (paged) => emit(
        state.copyWith(
          status: NewFeedStatus.loaded,
          posts: paged.items,
          nextCursor: paged.nextCursor,
          hasMore: paged.hasMore,
        ),
      ),
    );
  }

  void _onTabChanged(NewFeedTabChanged event, Emitter<NewFeedState> emit) {
    final tab = event.tabIndex == 0 ? NewFeedTab.feed : NewFeedTab.message;
    emit(state.copyWith(selectedTab: tab));
  }

  Future<void> _onPostLiked(
    NewFeedPostLiked event,
    Emitter<NewFeedState> emit,
  ) async {
    final previousPosts = state.posts;

    // Optimistic update
    emit(
      state.copyWith(
        posts: previousPosts.map((post) {
          if (post.id != event.postId) return post;
          return post.copyWith(
            isLiked: !post.isLiked,
            likeCount: post.isLiked ? post.likeCount - 1 : post.likeCount + 1,
          );
        }).toList(),
      ),
    );

    final result = await _toggleLikeUsecase(
      ToggleLikeParams(postId: event.postId),
    );

    // Rollback on failure
    result.fold(
      (_) => emit(state.copyWith(posts: previousPosts)),
      (_) {
        // update list with the new like count
        emit(state.copyWith(posts: previousPosts.map((post) {
          if (post.id != event.postId) return post;
          return post.copyWith(
            isLiked: !post.isLiked,
            likeCount: post.isLiked ? post.likeCount - 1 : post.likeCount + 1,
          );
        }).toList()));
      },
    );
  }

  Future<void> _onRefreshed(
    NewFeedRefreshed event,
    Emitter<NewFeedState> emit,
  ) async {
    emit(
      state.copyWith(
        status: NewFeedStatus.loading,
        nextCursor: null,
        hasMore: true,
      ),
    );
    final result = await _getNewfeedUsecase(const GetNewfeedParams());
    result.fold(
      (failure) => emit(
        state.copyWith(
          status: NewFeedStatus.error,
          errorMessage: failure.message,
        ),
      ),
      (paged) => emit(
        state.copyWith(
          status: NewFeedStatus.loaded,
          posts: paged.items,
          nextCursor: paged.nextCursor,
          hasMore: paged.hasMore,
        ),
      ),
    );
  }

  Future<void> _onLoadMore(
    NewFeedLoadMore event,
    Emitter<NewFeedState> emit,
  ) async {
    if (!state.hasMore || state.isLoadingMore) return;

    emit(state.copyWith(isLoadingMore: true));
    final result = await _getNewfeedUsecase(
      GetNewfeedParams(cursor: state.nextCursor),
    );
    result.fold(
      (failure) => emit(state.copyWith(isLoadingMore: false)),
      (paged) => emit(
        state.copyWith(
          isLoadingMore: false,
          posts: [...state.posts, ...paged.items],
          nextCursor: paged.nextCursor,
          hasMore: paged.hasMore,
        ),
      ),
    );
  }

  Future<void> _onPostSubmitted(
    NewFeedPostSubmitted event,
    Emitter<NewFeedState> emit,
  ) async {
    emit(state.copyWith(isSubmittingPost: true, submitPostError: null));
    final result = await _createPostUsecase(
      CreatePostParams(
        title: event.title,
        content: event.content,
        images: event.images,
        videos: event.videos,
      ),
    );
    result.fold(
      (failure) => emit(
        state.copyWith(
          isSubmittingPost: false,
          submitPostError: failure.message,
        ),
      ),
      (_) {
        emit(state.copyWith(isSubmittingPost: false));

        add(NewFeedStarted());
      },
    );
  }

  Future<void> _onPostDeleted(
    NewFeedPostDeleted event,
    Emitter<NewFeedState> emit,
  ) async {
    // Optimistic removal
    final previousPosts = state.posts;
    emit(
      state.copyWith(
        posts: previousPosts
            .where((p) => p.id != event.postId)
            .toList(),
      ),
    );

    final result = await _deletePostUsecase(
      DeletePostParams(postId: event.postId),
    );

    // Rollback on failure
    result.fold(
      (failure) => emit(state.copyWith(posts: previousPosts)),
      (_) {},
    );
  }

  void _onPostUpdated(
    NewFeedPostUpdated event,
    Emitter<NewFeedState> emit,
  ) {
    emit(
      state.copyWith(
        posts: state.posts
            .map((p) => p.id == event.updatedPost.id ? event.updatedPost : p)
            .toList(),
      ),
    );
  }
}

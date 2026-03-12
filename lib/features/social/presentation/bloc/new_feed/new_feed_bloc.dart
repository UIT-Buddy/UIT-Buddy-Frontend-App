import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uit_buddy_mobile/features/social/domain/usecases/create_post_usecase.dart';
import 'package:uit_buddy_mobile/features/social/domain/usecases/get_newfeed_usecase.dart';
import 'package:uit_buddy_mobile/features/social/presentation/bloc/new_feed/new_feed_event.dart';
import 'package:uit_buddy_mobile/features/social/presentation/bloc/new_feed/new_feed_state.dart';

class NewFeedBloc extends Bloc<NewFeedEvent, NewFeedState> {
  NewFeedBloc({
    required GetNewfeedUsecase getNewfeedUsecase,
    required CreatePostUsecase createPostUsecase,
  }) : _getNewfeedUsecase = getNewfeedUsecase,
       _createPostUsecase = createPostUsecase,
       super(const NewFeedState()) {
    on<NewFeedStarted>(_onNewFeedStarted);
    on<NewFeedTabChanged>(_onTabChanged);
    on<NewFeedPostLiked>(_onPostLiked);
    on<NewFeedRefreshed>(_onRefreshed);
    on<NewFeedLoadMore>(_onLoadMore);
    on<NewFeedPostSubmitted>(_onPostSubmitted);
  }

  final GetNewfeedUsecase _getNewfeedUsecase;
  final CreatePostUsecase _createPostUsecase;

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

  void _onPostLiked(NewFeedPostLiked event, Emitter<NewFeedState> emit) {
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
      (newPost) {
        emit(state.copyWith(isSubmittingPost: false, submitPostError: null));
        add(const NewFeedStarted());
      },
    );
  }
}

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uit_buddy_mobile/features/social/domain/usecases/get_newfeed_usecase.dart';
import 'package:uit_buddy_mobile/features/social/presentation/bloc/new_feed/new_feed_event.dart';
import 'package:uit_buddy_mobile/features/social/presentation/bloc/new_feed/new_feed_state.dart';

class NewFeedBloc extends Bloc<NewFeedEvent, NewFeedState> {
  NewFeedBloc({required GetNewfeedUsecase getNewfeedUsecase})
    : _getNewfeedUsecase = getNewfeedUsecase,
      super(const NewFeedState()) {
    on<NewFeedStarted>(_onNewFeedStarted);
    on<NewFeedTabChanged>(_onTabChanged);
    on<NewFeedPostLiked>(_onPostLiked);
    on<NewFeedRefreshed>(_onRefreshed);
    on<NewFeedLoadMore>(_onLoadMore);
  }

  final GetNewfeedUsecase _getNewfeedUsecase;

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
}

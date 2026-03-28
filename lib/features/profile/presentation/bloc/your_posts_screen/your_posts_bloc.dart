import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uit_buddy_mobile/features/profile/domain/usecases/get_posts_usecase.dart';
import 'package:uit_buddy_mobile/features/profile/domain/usecases/delete_post_usecase.dart';
import 'package:uit_buddy_mobile/features/profile/domain/usecases/toggle_post_like_usecase.dart';
import 'package:uit_buddy_mobile/features/profile/presentation/bloc/your_posts_screen/your_posts_event.dart';
import 'package:uit_buddy_mobile/features/profile/presentation/bloc/your_posts_screen/your_posts_state.dart';

class YourPostsBloc extends Bloc<YourPostsEvent, YourPostsState> {
  YourPostsBloc({
    required GetPostsUsecase getPostsUsecase,
    required DeleteYourPostUsecase deletePostUsecase,
    required TogglePostLikeUsecase togglePostLikeUsecase,
  }) : _getPostsUsecase = getPostsUsecase,
       _deletePostUsecase = deletePostUsecase,
       _togglePostLikeUsecase = togglePostLikeUsecase,
       super(const YourPostsState()) {
    on<YourPostsLoaded>(_onLoaded);
    on<YourPostsRefreshed>(_onRefreshed);
    on<YourPostsLoadMore>(_onLoadMore);
    on<YourPostsSearchChanged>(_onSearchChanged);
    on<YourPostsPostLiked>(_onPostLiked);
    on<YourPostsPostDeleted>(_onPostDeleted);
    on<YourPostsPostUpdated>(_onPostUpdated);
  }

  final GetPostsUsecase _getPostsUsecase;
  final DeleteYourPostUsecase _deletePostUsecase;
  final TogglePostLikeUsecase _togglePostLikeUsecase;

  Future<void> _onLoaded(
    YourPostsLoaded event,
    Emitter<YourPostsState> emit,
  ) async {
    emit(state.copyWith(status: YourPostsStatus.loading));
    final result = await _getPostsUsecase(const GetPostsParams());
    result.fold(
      (failure) => emit(
        state.copyWith(
          status: YourPostsStatus.error,
          errorMessage: failure.message,
        ),
      ),
      (paged) => emit(
        state.copyWith(
          status: YourPostsStatus.loaded,
          posts: paged.items,
          filtered: paged.items,
          nextCursor: paged.nextCursor,
          hasMore: paged.hasMore,
          searchQuery: '',
        ),
      ),
    );
  }

  Future<void> _onRefreshed(
    YourPostsRefreshed event,
    Emitter<YourPostsState> emit,
  ) async {
    emit(
      state.copyWith(
        status: YourPostsStatus.loading,
        nextCursor: null,
        hasMore: true,
      ),
    );
    final result = await _getPostsUsecase(const GetPostsParams());
    result.fold(
      (failure) => emit(
        state.copyWith(
          status: YourPostsStatus.error,
          errorMessage: failure.message,
        ),
      ),
      (paged) => emit(
        state.copyWith(
          status: YourPostsStatus.loaded,
          posts: paged.items,
          filtered: paged.items,
          nextCursor: paged.nextCursor,
          hasMore: paged.hasMore,
          searchQuery: '',
        ),
      ),
    );
  }

  Future<void> _onLoadMore(
    YourPostsLoadMore event,
    Emitter<YourPostsState> emit,
  ) async {
    if (!state.hasMore || state.isLoadingMore) return;

    emit(state.copyWith(isLoadingMore: true));
    final result = await _getPostsUsecase(
      GetPostsParams(cursor: state.nextCursor),
    );
    result.fold((failure) => emit(state.copyWith(isLoadingMore: false)), (
      paged,
    ) {
      final allPosts = [...state.posts, ...paged.items];
      final query = state.searchQuery.trim().toLowerCase();
      final filtered = query.isEmpty
          ? allPosts
          : allPosts
                .where((p) => p.content.toLowerCase().contains(query))
                .toList();
      emit(
        state.copyWith(
          isLoadingMore: false,
          posts: allPosts,
          filtered: filtered,
          nextCursor: paged.nextCursor,
          hasMore: paged.hasMore,
        ),
      );
    });
  }

  Future<void> _onPostLiked(
    YourPostsPostLiked event,
    Emitter<YourPostsState> emit,
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

    final result = await _togglePostLikeUsecase(
      TogglePostLikeParams(postId: event.postId),
    );

    // Rollback on failure
    result.fold((_) => emit(state.copyWith(posts: previousPosts)), (_) {
      // Like successful, keep the update
      final query = state.searchQuery.trim().toLowerCase();
      final filtered = query.isEmpty
          ? state.posts
          : state.posts
                .where((p) => p.content.toLowerCase().contains(query))
                .toList();
      emit(state.copyWith(filtered: filtered));
    });
  }

  Future<void> _onPostDeleted(
    YourPostsPostDeleted event,
    Emitter<YourPostsState> emit,
  ) async {
    final result = await _deletePostUsecase(
      DeletePostParams(postId: event.postId),
    );

    result.fold(
      (_) {
        // On failure, do nothing (could show error)
      },
      (_) {
        // On success, remove from list
        final updatedPosts = state.posts
            .where((p) => p.id != event.postId)
            .toList();
        final updatedFiltered = state.filtered
            .where((p) => p.id != event.postId)
            .toList();
        emit(state.copyWith(posts: updatedPosts, filtered: updatedFiltered));
      },
    );
  }

  void _onSearchChanged(
    YourPostsSearchChanged event,
    Emitter<YourPostsState> emit,
  ) {
    final query = event.query.trim().toLowerCase();
    final filtered = query.isEmpty
        ? state.posts
        : state.posts
              .where((p) => p.content.toLowerCase().contains(query))
              .toList();
    emit(state.copyWith(searchQuery: event.query, filtered: filtered));
  }

  void _onPostUpdated(
    YourPostsPostUpdated event,
    Emitter<YourPostsState> emit,
  ) {
    final updatedPosts = state.posts.map((p) {
      if (p.id != event.updatedPost.id) return p;
      return event.updatedPost;
    }).toList();

    final query = state.searchQuery.trim().toLowerCase();
    final updatedFiltered = query.isEmpty
        ? updatedPosts
        : updatedPosts
              .where((p) => p.content.toLowerCase().contains(query))
              .toList();

    emit(state.copyWith(posts: updatedPosts, filtered: updatedFiltered));
  }
}

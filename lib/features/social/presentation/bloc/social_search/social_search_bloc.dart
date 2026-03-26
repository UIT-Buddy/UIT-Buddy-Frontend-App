import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uit_buddy_mobile/features/social/domain/entities/post_entity.dart';
import 'package:uit_buddy_mobile/features/social/domain/entities/search_user_entity.dart';
import 'package:uit_buddy_mobile/features/social/domain/usecases/search_posts_usecase.dart';
import 'package:uit_buddy_mobile/features/social/domain/usecases/search_users_usecase.dart';
import 'package:uit_buddy_mobile/features/social/presentation/bloc/social_search/social_search_event.dart';
import 'package:uit_buddy_mobile/features/social/presentation/bloc/social_search/social_search_state.dart';

class SocialSearchBloc extends Bloc<SocialSearchEvent, SocialSearchState> {
  SocialSearchBloc({
    required SearchUsersUsecase searchUsersUsecase,
    required SearchPostsUsecase searchPostsUsecase,
  }) : _searchUsersUsecase = searchUsersUsecase,
       _searchPostsUsecase = searchPostsUsecase,
       super(const SocialSearchState()) {
    on<SocialSearchStarted>(_onQueryRequested);
    on<SocialSearchSubmitted>(_onQueryRequested);
    on<SocialSearchRetried>(_onRetried);
    on<SocialSearchUsersLoadMore>(_onUsersLoadMore);
    on<SocialSearchPostsLoadMore>(_onPostsLoadMore);
  }

  final SearchUsersUsecase _searchUsersUsecase;
  final SearchPostsUsecase _searchPostsUsecase;

  Future<void> _onQueryRequested(
    SocialSearchEvent event,
    Emitter<SocialSearchState> emit,
  ) async {
    final query = switch (event) {
      SocialSearchStarted started => started.query.trim(),
      SocialSearchSubmitted submitted => submitted.query.trim(),
      _ => state.query.trim(),
    };

    if (query.isEmpty) {
      emit(const SocialSearchState());
      return;
    }

    emit(
      state.copyWith(
        query: query,
        isLoading: true,
        users: const [],
        posts: const [],
        usersError: null,
        postsError: null,
        nextUsersPage: null,
        nextPostsPage: null,
        hasMoreUsers: false,
        hasMorePosts: false,
      ),
    );

    final usersFuture = _searchUsersUsecase(SearchUsersParams(keyword: query));
    final postsFuture = _searchPostsUsecase(SearchPostsParams(keyword: query));

    final usersResult = await usersFuture;
    final postsResult = await postsFuture;

    var users = const <SearchUserEntity>[];
    var posts = const <PostEntity>[];
    String? usersError;
    String? postsError;
    int? nextUsersPage;
    int? nextPostsPage;
    var hasMoreUsers = false;
    var hasMorePosts = false;

    usersResult.fold((failure) => usersError = failure.message, (paged) {
      users = paged.items;
      nextUsersPage = _parseNextPage(paged.nextCursor);
      hasMoreUsers = paged.hasMore;
    });

    postsResult.fold((failure) => postsError = failure.message, (paged) {
      posts = paged.items;
      nextPostsPage = _parseNextPage(paged.nextCursor);
      hasMorePosts = paged.hasMore;
    });

    emit(
      state.copyWith(
        query: query,
        isLoading: false,
        users: users,
        posts: posts,
        usersError: usersError,
        postsError: postsError,
        nextUsersPage: nextUsersPage,
        nextPostsPage: nextPostsPage,
        hasMoreUsers: hasMoreUsers,
        hasMorePosts: hasMorePosts,
      ),
    );
  }

  Future<void> _onRetried(
    SocialSearchRetried event,
    Emitter<SocialSearchState> emit,
  ) async {
    if (state.query.isEmpty) return;
    add(SocialSearchSubmitted(query: state.query));
  }

  Future<void> _onUsersLoadMore(
    SocialSearchUsersLoadMore event,
    Emitter<SocialSearchState> emit,
  ) async {
    final nextPage = state.nextUsersPage;
    if (state.query.isEmpty ||
        nextPage == null ||
        state.isLoading ||
        state.isLoadingMoreUsers ||
        !state.hasMoreUsers) {
      return;
    }

    emit(state.copyWith(isLoadingMoreUsers: true));

    final result = await _searchUsersUsecase(
      SearchUsersParams(keyword: state.query, page: nextPage),
    );

    result.fold(
      (failure) => emit(
        state.copyWith(isLoadingMoreUsers: false, usersError: failure.message),
      ),
      (paged) => emit(
        state.copyWith(
          isLoadingMoreUsers: false,
          users: [...state.users, ...paged.items],
          nextUsersPage: _parseNextPage(paged.nextCursor),
          hasMoreUsers: paged.hasMore,
        ),
      ),
    );
  }

  Future<void> _onPostsLoadMore(
    SocialSearchPostsLoadMore event,
    Emitter<SocialSearchState> emit,
  ) async {
    final nextPage = state.nextPostsPage;
    if (state.query.isEmpty ||
        nextPage == null ||
        state.isLoading ||
        state.isLoadingMorePosts ||
        !state.hasMorePosts) {
      return;
    }

    emit(state.copyWith(isLoadingMorePosts: true));

    final result = await _searchPostsUsecase(
      SearchPostsParams(keyword: state.query, page: nextPage),
    );

    result.fold(
      (failure) => emit(
        state.copyWith(isLoadingMorePosts: false, postsError: failure.message),
      ),
      (paged) => emit(
        state.copyWith(
          isLoadingMorePosts: false,
          posts: [...state.posts, ...paged.items],
          nextPostsPage: _parseNextPage(paged.nextCursor),
          hasMorePosts: paged.hasMore,
        ),
      ),
    );
  }

  int? _parseNextPage(String? nextCursor) {
    if (nextCursor == null || nextCursor.isEmpty) return null;
    return int.tryParse(nextCursor);
  }
}

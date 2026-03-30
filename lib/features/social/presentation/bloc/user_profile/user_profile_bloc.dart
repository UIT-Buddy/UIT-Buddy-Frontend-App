import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uit_buddy_mobile/features/social/domain/entities/other_people_entity.dart';
import 'package:uit_buddy_mobile/features/social/domain/usecases/delete_post_usecase.dart';
import 'package:uit_buddy_mobile/features/social/domain/usecases/get_user_posts_usecase.dart';
import 'package:uit_buddy_mobile/features/social/domain/usecases/get_user_profile_usecase.dart';
import 'package:uit_buddy_mobile/features/social/domain/usecases/respond_friend_request_usecase.dart';
import 'package:uit_buddy_mobile/features/social/domain/usecases/toggle_like_usecase.dart';
import 'package:uit_buddy_mobile/features/social/domain/usecases/toggle_friend_request_usecase.dart';
import 'package:uit_buddy_mobile/features/social/domain/usecases/unfriend_usecase.dart';
import 'package:uit_buddy_mobile/features/social/domain/repositories/user_profile_repository.dart';
import 'package:uit_buddy_mobile/features/social/domain/entities/search_user_entity.dart';
import 'package:uit_buddy_mobile/features/social/presentation/bloc/user_profile/user_profile_event.dart';
import 'package:uit_buddy_mobile/features/social/presentation/bloc/user_profile/user_profile_state.dart';

class UserProfileBloc extends Bloc<UserProfileEvent, UserProfileState> {
  UserProfileBloc({
    required GetUserProfileUsecase getUserProfileUsecase,
    required GetUserPostsUsecase getUserPostsUsecase,
    required ToggleFriendRequestUsecase toggleFriendRequestUsecase,
    required RespondFriendRequestUsecase respondFriendRequestUsecase,
    required UnfriendUsecase unfriendUsecase,
    required ToggleLikeUsecase toggleLikeUsecase,
    required DeletePostUsecase deletePostUsecase,
  }) : _getUserProfileUsecase = getUserProfileUsecase,
       _getUserPostsUsecase = getUserPostsUsecase,
       _toggleFriendRequestUsecase = toggleFriendRequestUsecase,
       _respondFriendRequestUsecase = respondFriendRequestUsecase,
       _unfriendUsecase = unfriendUsecase,
       _toggleLikeUsecase = toggleLikeUsecase,
       _deletePostUsecase = deletePostUsecase,
       super(const UserProfileState()) {
    on<UserProfileStarted>(_onStarted);
    on<UserProfileFriendActionSubmitted>(_onFriendActionSubmitted);
    on<UserProfileFeedbackCleared>(_onFeedbackCleared);
    on<UserProfilePostsRefreshed>(_onPostsRefreshed);
    on<UserProfilePostsLoadMore>(_onPostsLoadMore);
    on<UserProfilePostLiked>(_onPostLiked);
    on<UserProfilePostUpdated>(_onPostUpdated);
    on<UserProfilePostDeleted>(_onPostDeleted);
  }

  final GetUserProfileUsecase _getUserProfileUsecase;
  final GetUserPostsUsecase _getUserPostsUsecase;
  final ToggleFriendRequestUsecase _toggleFriendRequestUsecase;
  final RespondFriendRequestUsecase _respondFriendRequestUsecase;
  final UnfriendUsecase _unfriendUsecase;
  final ToggleLikeUsecase _toggleLikeUsecase;
  final DeletePostUsecase _deletePostUsecase;

  Future<void> _onStarted(
    UserProfileStarted event,
    Emitter<UserProfileState> emit,
  ) async {
    emit(
      state.copyWith(
        status: UserProfileStatus.loading,
        errorMessage: null,
        postsStatus: UserProfilePostsStatus.loading,
        posts: const [],
        postsErrorMessage: null,
        nextPostsPage: null,
        hasMorePosts: true,
        isLoadingMorePosts: false,
      ),
    );

    final result = await _getUserProfileUsecase(
      GetUserProfileParams(mssv: event.mssv),
    );
    OtherPeopleEntity? loadedUser;
    result.fold(
      (failure) => emit(
        state.copyWith(
          status: UserProfileStatus.error,
          errorMessage: failure.message,
        ),
      ),
      (user) {
        loadedUser = user;
        emit(state.copyWith(status: UserProfileStatus.loaded, user: user));
      },
    );

    if (loadedUser != null) {
      await _loadPosts(emit, mssv: event.mssv, page: 1);
    }
  }

  Future<void> _onFriendActionSubmitted(
    UserProfileFriendActionSubmitted event,
    Emitter<UserProfileState> emit,
  ) async {
    final user = state.user;
    if (user == null || state.isFriendActionLoading) return;

    emit(
      state.copyWith(
        isFriendActionLoading: true,
        activeFriendAction: event.action,
        actionErrorMessage: null,
        actionSuccessMessage: null,
      ),
    );

    final result = await switch (event.action) {
      UserProfileFriendAction.sendRequest ||
      UserProfileFriendAction.cancelRequest => _toggleFriendRequestUsecase(
        ToggleFriendRequestParams(receiverMssv: user.mssv),
      ),
      UserProfileFriendAction.acceptRequest => _respondFriendRequestUsecase(
        RespondFriendRequestParams(
          senderMssv: user.mssv,
          action: FriendRequestResponseAction.accept,
        ),
      ),
      UserProfileFriendAction.rejectRequest => _respondFriendRequestUsecase(
        RespondFriendRequestParams(
          senderMssv: user.mssv,
          action: FriendRequestResponseAction.reject,
        ),
      ),
      UserProfileFriendAction.unfriend => _unfriendUsecase(
        UnfriendParams(friendMssv: user.mssv),
      ),
    };

    result.fold(
      (failure) => emit(
        state.copyWith(
          isFriendActionLoading: false,
          activeFriendAction: null,
          actionErrorMessage: failure.message,
        ),
      ),
      (_) => emit(
        state.copyWith(
          user: user.copyWith(
            friendStatus: _nextStatus(user.friendStatus, event.action),
          ),
          isFriendActionLoading: false,
          activeFriendAction: null,
          actionSuccessMessage: _successMessage(event.action),
        ),
      ),
    );
  }

  void _onFeedbackCleared(
    UserProfileFeedbackCleared event,
    Emitter<UserProfileState> emit,
  ) {
    emit(state.copyWith(actionErrorMessage: null, actionSuccessMessage: null));
  }

  Future<void> _onPostsRefreshed(
    UserProfilePostsRefreshed event,
    Emitter<UserProfileState> emit,
  ) async {
    final user = state.user;
    if (user == null) return;

    emit(
      state.copyWith(
        postsStatus: UserProfilePostsStatus.loading,
        postsErrorMessage: null,
        nextPostsPage: null,
        hasMorePosts: true,
        isLoadingMorePosts: false,
      ),
    );

    await _loadPosts(emit, mssv: user.mssv, page: 1);
  }

  Future<void> _onPostsLoadMore(
    UserProfilePostsLoadMore event,
    Emitter<UserProfileState> emit,
  ) async {
    final user = state.user;
    final nextPage = state.nextPostsPage;
    if (user == null ||
        nextPage == null ||
        !state.hasMorePosts ||
        state.isLoadingMorePosts ||
        state.postsStatus == UserProfilePostsStatus.loading) {
      return;
    }

    emit(state.copyWith(isLoadingMorePosts: true, postsErrorMessage: null));

    final result = await _getUserPostsUsecase(
      GetUserPostsParams(mssv: user.mssv, page: nextPage),
    );

    result.fold(
      (failure) => emit(
        state.copyWith(
          isLoadingMorePosts: false,
          postsErrorMessage: failure.message,
        ),
      ),
      (paged) => emit(
        state.copyWith(
          postsStatus: UserProfilePostsStatus.loaded,
          posts: [...state.posts, ...paged.items],
          isLoadingMorePosts: false,
          nextPostsPage: paged.items.isEmpty ? null : _parseNextPage(paged.nextCursor),
          hasMorePosts: paged.items.isEmpty ? false : paged.hasMore,
          postsErrorMessage: null,
        ),
      ),
    );
  }

  Future<void> _onPostLiked(
    UserProfilePostLiked event,
    Emitter<UserProfileState> emit,
  ) async {
    final previousPosts = state.posts;

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

    result.fold((_) => emit(state.copyWith(posts: previousPosts)), (_) {});
  }

  void _onPostUpdated(
    UserProfilePostUpdated event,
    Emitter<UserProfileState> emit,
  ) {
    emit(
      state.copyWith(
        posts: state.posts
            .map(
              (post) =>
                  post.id == event.updatedPost.id ? event.updatedPost : post,
            )
            .toList(),
      ),
    );
  }

  Future<void> _onPostDeleted(
    UserProfilePostDeleted event,
    Emitter<UserProfileState> emit,
  ) async {
    final previousPosts = state.posts;
    emit(
      state.copyWith(
        posts: previousPosts.where((post) => post.id != event.postId).toList(),
      ),
    );

    final result = await _deletePostUsecase(
      DeletePostParams(postId: event.postId),
    );

    result.fold((_) => emit(state.copyWith(posts: previousPosts)), (_) {});
  }

  Future<void> _loadPosts(
    Emitter<UserProfileState> emit, {
    required String mssv,
    required int page,
  }) async {
    final result = await _getUserPostsUsecase(
      GetUserPostsParams(mssv: mssv, page: page),
    );

    result.fold(
      (failure) => emit(
        state.copyWith(
          postsStatus: UserProfilePostsStatus.error,
          postsErrorMessage: failure.message,
          posts: const [],
          nextPostsPage: null,
          hasMorePosts: false,
          isLoadingMorePosts: false,
        ),
      ),
      (paged) => emit(
        state.copyWith(
          postsStatus: UserProfilePostsStatus.loaded,
          posts: paged.items,
          postsErrorMessage: null,
          nextPostsPage: paged.items.isEmpty ? null : _parseNextPage(paged.nextCursor),
          hasMorePosts: paged.items.isEmpty ? false : paged.hasMore,
          isLoadingMorePosts: false,
        ),
      ),
    );
  }

  int? _parseNextPage(String? nextCursor) {
    if (nextCursor == null || nextCursor.isEmpty) return null;
    return int.tryParse(nextCursor);
  }

  FriendStatus _nextStatus(
    FriendStatus currentStatus,
    UserProfileFriendAction action,
  ) {
    return switch (action) {
      UserProfileFriendAction.sendRequest => FriendStatus.pending,
      UserProfileFriendAction.cancelRequest => FriendStatus.none,
      UserProfileFriendAction.acceptRequest => FriendStatus.friends,
      UserProfileFriendAction.rejectRequest => FriendStatus.none,
      UserProfileFriendAction.unfriend => FriendStatus.none,
    };
  }

  String _successMessage(UserProfileFriendAction action) {
    return switch (action) {
      UserProfileFriendAction.sendRequest => 'Friend request sent.',
      UserProfileFriendAction.cancelRequest => 'Friend request canceled.',
      UserProfileFriendAction.acceptRequest => 'Friend request accepted.',
      UserProfileFriendAction.rejectRequest => 'Friend request rejected.',
      UserProfileFriendAction.unfriend => 'Friend removed successfully.',
    };
  }
}

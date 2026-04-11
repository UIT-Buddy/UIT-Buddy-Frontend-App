import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uit_buddy_mobile/features/profile/domain/entities/cursor_params.dart';
import 'package:uit_buddy_mobile/features/profile/domain/entities/friend_entity.dart';
import 'package:uit_buddy_mobile/features/profile/domain/usecases/friends/get_friends_usecase.dart';
import 'package:uit_buddy_mobile/features/profile/domain/usecases/friends/get_pending_requests_usecase.dart';
import 'package:uit_buddy_mobile/features/profile/domain/usecases/friends/get_sent_requests_usecase.dart';
import 'package:uit_buddy_mobile/features/profile/domain/usecases/friends/respond_friend_request_usecase.dart';
import 'package:uit_buddy_mobile/features/profile/domain/usecases/friends/toggle_friend_request_usecase.dart';
import 'package:uit_buddy_mobile/features/profile/domain/usecases/friends/unfriend_usecase.dart';
import 'package:uit_buddy_mobile/features/profile/presentation/bloc/your_friends_screen/friends_event.dart';
import 'package:uit_buddy_mobile/features/profile/presentation/bloc/your_friends_screen/friends_state.dart';

class FriendsBloc extends Bloc<FriendsEvent, FriendsState> {
  FriendsBloc({
    required GetFriendsUsecase getFriendsUsecase,
    required GetSentRequestsUsecase getSentRequestsUsecase,
    required GetPendingRequestsUsecase getPendingRequestsUsecase,
    required ToggleFriendRequestUsecase toggleFriendRequestUsecase,
    required UnfriendUsecase unfriendUsecase,
    required RespondFriendRequestUsecase respondFriendRequestUsecase,
  }) : _getFriendsUsecase = getFriendsUsecase,
       _getSentRequestsUsecase = getSentRequestsUsecase,
       _getPendingRequestsUsecase = getPendingRequestsUsecase,
       _toggleFriendRequestUsecase = toggleFriendRequestUsecase,
       _unfriendUsecase = unfriendUsecase,
       _respondFriendRequestUsecase = respondFriendRequestUsecase,
       super(const FriendsState()) {
    on<FriendsLoaded>(_onLoaded);
    on<FriendsRefreshed>(_onRefreshed);
    on<FriendsLoadMore>(_onLoadMore);
    on<FriendsPrimaryTabChanged>(_onPrimaryTabChanged);
    on<FriendsInviteTabChanged>(_onInviteTabChanged);
    on<FriendsSearchChanged>(_onSearchChanged);
    on<FriendsToggleFriendRequest>(_onToggleFriendRequest);
    on<FriendsUnfriend>(_onUnfriend);
    on<FriendsRespondToFriendRequest>(_onRespondToFriendRequest);
    on<FriendsFeedbackCleared>(_onFeedbackCleared);
  }

  final GetFriendsUsecase _getFriendsUsecase;
  final GetSentRequestsUsecase _getSentRequestsUsecase;
  final GetPendingRequestsUsecase _getPendingRequestsUsecase;
  final ToggleFriendRequestUsecase _toggleFriendRequestUsecase;
  final UnfriendUsecase _unfriendUsecase;
  final RespondFriendRequestUsecase _respondFriendRequestUsecase;

  static const int _pageSize = 10;

  Future<void> _onLoaded(
    FriendsLoaded event,
    Emitter<FriendsState> emit,
  ) async {
    await _loadCurrentTab(emit, refresh: true);
  }

  Future<void> _onRefreshed(
    FriendsRefreshed event,
    Emitter<FriendsState> emit,
  ) async {
    await _loadCurrentTab(emit, refresh: true);
  }

  Future<void> _onLoadMore(
    FriendsLoadMore event,
    Emitter<FriendsState> emit,
  ) async {
    if (state.isLoadingMore || !state.activeHasMore) return;
    if (state.activeNextCursor == null || state.activeNextCursor!.isEmpty) {
      return;
    }
    await _loadCurrentTab(emit, loadMore: true);
  }

  Future<void> _onPrimaryTabChanged(
    FriendsPrimaryTabChanged event,
    Emitter<FriendsState> emit,
  ) async {
    if (event.tab == state.curSection) return;

    final switched = _withFiltered(
      state.copyWith(
        curSection: event.tab,
        status: FriendsStatus.loaded,
        errorMessage: null,
      ),
    );
    emit(switched);

    if (switched.activeItems.isEmpty) {
      await _loadCurrentTab(emit, refresh: true);
    }
  }

  Future<void> _onInviteTabChanged(
    FriendsInviteTabChanged event,
    Emitter<FriendsState> emit,
  ) async {
    if (event.tab == state.curInviteSection) return;

    final switched = _withFiltered(
      state.copyWith(
        curInviteSection: event.tab,
        status: FriendsStatus.loaded,
        errorMessage: null,
      ),
    );
    emit(switched);

    if (switched.curSection == FriendsPrimaryTab.invites &&
        switched.activeItems.isEmpty) {
      await _loadCurrentTab(emit, refresh: true);
    }
  }

  void _onSearchChanged(
    FriendsSearchChanged event,
    Emitter<FriendsState> emit,
  ) {
    emit(_withFiltered(state.copyWith(searchQuery: event.query)));
  }

  Future<void> _onToggleFriendRequest(
    FriendsToggleFriendRequest event,
    Emitter<FriendsState> emit,
  ) async {
    if (state.isPerformingAction) return;

    emit(
      state.copyWith(
        isPerformingAction: true,
        activeActionMssv: event.receiverMssv,
        actionErrorMessage: null,
        actionSuccessMessage: null,
      ),
    );

    final result = await _toggleFriendRequestUsecase(event.receiverMssv);
    result.fold(
      (failure) => emit(
        state.copyWith(
          isPerformingAction: false,
          activeActionMssv: null,
          actionErrorMessage: failure.message,
        ),
      ),
      (_) {
        final updatedSent = state.sentFriends
            .where((friend) => friend.mssv != event.receiverMssv)
            .toList();

        emit(
          _withFiltered(
            state.copyWith(
              isPerformingAction: false,
              activeActionMssv: null,
              sentFriends: updatedSent,
              actionSuccessMessage: 'Invite canceled.',
            ),
          ),
        );
      },
    );
  }

  Future<void> _onUnfriend(
    FriendsUnfriend event,
    Emitter<FriendsState> emit,
  ) async {
    if (state.isPerformingAction) return;

    emit(
      state.copyWith(
        isPerformingAction: true,
        activeActionMssv: event.friendMssv,
        actionErrorMessage: null,
        actionSuccessMessage: null,
      ),
    );

    final result = await _unfriendUsecase(event.friendMssv);
    result.fold(
      (failure) => emit(
        state.copyWith(
          isPerformingAction: false,
          activeActionMssv: null,
          actionErrorMessage: failure.message,
        ),
      ),
      (_) {
        final updatedFriends = state.friends
            .where((friend) => friend.mssv != event.friendMssv)
            .toList();

        emit(
          _withFiltered(
            state.copyWith(
              isPerformingAction: false,
              activeActionMssv: null,
              friends: updatedFriends,
              actionSuccessMessage: 'Unfriended successfully.',
            ),
          ),
        );
      },
    );
  }

  Future<void> _onRespondToFriendRequest(
    FriendsRespondToFriendRequest event,
    Emitter<FriendsState> emit,
  ) async {
    if (state.isPerformingAction) return;

    emit(
      state.copyWith(
        isPerformingAction: true,
        activeActionMssv: event.senderMssv,
        actionErrorMessage: null,
        actionSuccessMessage: null,
      ),
    );

    final result = await _respondFriendRequestUsecase(
      RespondFriendParams(action: event.action, senderMssv: event.senderMssv),
    );

    result.fold(
      (failure) => emit(
        state.copyWith(
          isPerformingAction: false,
          activeActionMssv: null,
          actionErrorMessage: failure.message,
        ),
      ),
      (_) {
        FriendEntity? acceptedFriend;
        for (final friend in state.pendingFriends) {
          if (friend.mssv == event.senderMssv) {
            acceptedFriend = friend;
            break;
          }
        }

        final updatedPending = state.pendingFriends
            .where((friend) => friend.mssv != event.senderMssv)
            .toList();

        var updatedFriends = state.friends;
        if (event.action == 'ACCEPT' && acceptedFriend != null) {
          final exists = updatedFriends.any(
            (friend) => friend.mssv == acceptedFriend!.mssv,
          );
          if (!exists) {
            updatedFriends = [acceptedFriend, ...updatedFriends];
          }
        }

        emit(
          _withFiltered(
            state.copyWith(
              isPerformingAction: false,
              activeActionMssv: null,
              pendingFriends: updatedPending,
              friends: updatedFriends,
              actionSuccessMessage: event.action == 'ACCEPT'
                  ? 'Invite accepted.'
                  : 'Invite rejected.',
            ),
          ),
        );
      },
    );
  }

  void _onFeedbackCleared(
    FriendsFeedbackCleared event,
    Emitter<FriendsState> emit,
  ) {
    emit(state.copyWith(actionErrorMessage: null, actionSuccessMessage: null));
  }

  Future<void> _loadCurrentTab(
    Emitter<FriendsState> emit, {
    bool refresh = false,
    bool loadMore = false,
  }) async {
    if (state.curSection == FriendsPrimaryTab.friends) {
      await _loadFriends(emit, refresh: refresh, loadMore: loadMore);
      return;
    }

    if (state.curInviteSection == FriendsInviteTab.sent) {
      await _loadSent(emit, refresh: refresh, loadMore: loadMore);
      return;
    }

    await _loadPending(emit, refresh: refresh, loadMore: loadMore);
  }

  Future<void> _loadFriends(
    Emitter<FriendsState> emit, {
    required bool refresh,
    required bool loadMore,
  }) async {
    final cursor = loadMore ? state.friendsNextCursor : null;
    if (loadMore &&
        (cursor == null || cursor.isEmpty || !state.friendsHasMore)) {
      return;
    }

    emit(
      _withFiltered(
        state.copyWith(
          status: loadMore ? FriendsStatus.loaded : FriendsStatus.loading,
          isLoadingMore: loadMore,
          errorMessage: null,
          actionErrorMessage: null,
          actionSuccessMessage: null,
          friendsNextCursor: refresh && !loadMore
              ? null
              : state.friendsNextCursor,
          friendsHasMore: refresh && !loadMore ? true : state.friendsHasMore,
        ),
      ),
    );

    final result = await _getFriendsUsecase(
      CursorParams(cursor: cursor, limit: _pageSize),
    );

    result.fold(
      (failure) {
        final hasExistingItems = state.friends.isNotEmpty;
        emit(
          _withFiltered(
            state.copyWith(
              status: hasExistingItems
                  ? FriendsStatus.loaded
                  : FriendsStatus.error,
              isLoadingMore: false,
              errorMessage: hasExistingItems ? null : failure.message,
              actionErrorMessage: hasExistingItems ? failure.message : null,
            ),
          ),
        );
      },
      (paged) {
        final merged = loadMore
            ? [...state.friends, ...paged.items]
            : paged.items;
        emit(
          _withFiltered(
            state.copyWith(
              status: FriendsStatus.loaded,
              isLoadingMore: false,
              friends: merged,
              friendsNextCursor: paged.nextCursor,
              friendsHasMore: paged.hasMore,
              errorMessage: null,
            ),
          ),
        );
      },
    );
  }

  Future<void> _loadSent(
    Emitter<FriendsState> emit, {
    required bool refresh,
    required bool loadMore,
  }) async {
    final cursor = loadMore ? state.sentNextCursor : null;
    if (loadMore && (cursor == null || cursor.isEmpty || !state.sentHasMore)) {
      return;
    }

    emit(
      _withFiltered(
        state.copyWith(
          status: loadMore ? FriendsStatus.loaded : FriendsStatus.loading,
          isLoadingMore: loadMore,
          errorMessage: null,
          actionErrorMessage: null,
          actionSuccessMessage: null,
          sentNextCursor: refresh && !loadMore ? null : state.sentNextCursor,
          sentHasMore: refresh && !loadMore ? true : state.sentHasMore,
        ),
      ),
    );

    final result = await _getSentRequestsUsecase(
      CursorParams(cursor: cursor, limit: _pageSize),
    );

    result.fold(
      (failure) {
        final hasExistingItems = state.sentFriends.isNotEmpty;
        emit(
          _withFiltered(
            state.copyWith(
              status: hasExistingItems
                  ? FriendsStatus.loaded
                  : FriendsStatus.error,
              isLoadingMore: false,
              errorMessage: hasExistingItems ? null : failure.message,
              actionErrorMessage: hasExistingItems ? failure.message : null,
            ),
          ),
        );
      },
      (paged) {
        final merged = loadMore
            ? [...state.sentFriends, ...paged.items]
            : paged.items;
        emit(
          _withFiltered(
            state.copyWith(
              status: FriendsStatus.loaded,
              isLoadingMore: false,
              sentFriends: merged,
              sentNextCursor: paged.nextCursor,
              sentHasMore: paged.hasMore,
              errorMessage: null,
            ),
          ),
        );
      },
    );
  }

  Future<void> _loadPending(
    Emitter<FriendsState> emit, {
    required bool refresh,
    required bool loadMore,
  }) async {
    final cursor = loadMore ? state.pendingNextCursor : null;
    if (loadMore &&
        (cursor == null || cursor.isEmpty || !state.pendingHasMore)) {
      return;
    }

    emit(
      _withFiltered(
        state.copyWith(
          status: loadMore ? FriendsStatus.loaded : FriendsStatus.loading,
          isLoadingMore: loadMore,
          errorMessage: null,
          actionErrorMessage: null,
          actionSuccessMessage: null,
          pendingNextCursor: refresh && !loadMore
              ? null
              : state.pendingNextCursor,
          pendingHasMore: refresh && !loadMore ? true : state.pendingHasMore,
        ),
      ),
    );

    final result = await _getPendingRequestsUsecase(
      CursorParams(cursor: cursor, limit: _pageSize),
    );

    result.fold(
      (failure) {
        final hasExistingItems = state.pendingFriends.isNotEmpty;
        emit(
          _withFiltered(
            state.copyWith(
              status: hasExistingItems
                  ? FriendsStatus.loaded
                  : FriendsStatus.error,
              isLoadingMore: false,
              errorMessage: hasExistingItems ? null : failure.message,
              actionErrorMessage: hasExistingItems ? failure.message : null,
            ),
          ),
        );
      },
      (paged) {
        final merged = loadMore
            ? [...state.pendingFriends, ...paged.items]
            : paged.items;
        emit(
          _withFiltered(
            state.copyWith(
              status: FriendsStatus.loaded,
              isLoadingMore: false,
              pendingFriends: merged,
              pendingNextCursor: paged.nextCursor,
              pendingHasMore: paged.hasMore,
              errorMessage: null,
            ),
          ),
        );
      },
    );
  }

  FriendsState _withFiltered(FriendsState source) {
    final normalized = source.searchQuery.trim().toLowerCase();
    if (normalized.isEmpty) {
      return source.copyWith(filtered: source.activeItems);
    }

    final filtered = source.activeItems.where((friend) {
      final matchesName = friend.name.toLowerCase().contains(normalized);
      final matchesMssv = friend.mssv.toLowerCase().contains(normalized);
      return matchesName || matchesMssv;
    }).toList();

    return source.copyWith(filtered: filtered);
  }
}

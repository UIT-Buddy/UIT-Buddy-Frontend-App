import 'package:equatable/equatable.dart';
import 'package:uit_buddy_mobile/features/profile/domain/entities/friend_entity.dart';

enum FriendsStatus { initial, loading, loaded, error }

enum FriendsPrimaryTab { friends, invites }

enum FriendsInviteTab { sent, received }

enum FriendsRespondAction { accept, reject }

class FriendsState extends Equatable {
  const FriendsState({
    this.curSection = FriendsPrimaryTab.friends,
    this.curInviteSection = FriendsInviteTab.sent,
    this.status = FriendsStatus.initial,
    this.friends = const [],
    this.sentFriends = const [],
    this.pendingFriends = const [],
    this.filtered = const [],
    this.errorMessage,
    this.friendsNextCursor,
    this.sentNextCursor,
    this.pendingNextCursor,
    this.searchQuery = '',
    this.friendsHasMore = true,
    this.sentHasMore = true,
    this.pendingHasMore = true,
    this.isLoadingMore = false,
    this.isPerformingAction = false,
    this.activeActionMssv,
    this.actionErrorMessage,
    this.actionSuccessMessage,
  });

  final FriendsPrimaryTab curSection;
  final FriendsInviteTab curInviteSection;
  final FriendsStatus status;
  final List<FriendEntity> friends;
  final List<FriendEntity> sentFriends;
  final List<FriendEntity> pendingFriends;
  final List<FriendEntity> filtered;
  final String? errorMessage;
  final String? friendsNextCursor;
  final String? sentNextCursor;
  final String? pendingNextCursor;
  final String searchQuery;
  final bool friendsHasMore;
  final bool sentHasMore;
  final bool pendingHasMore;
  final bool isLoadingMore;
  final bool isPerformingAction;
  final String? activeActionMssv;
  final String? actionErrorMessage;
  final String? actionSuccessMessage;

  List<FriendEntity> get activeItems {
    if (curSection == FriendsPrimaryTab.friends) {
      return friends;
    }
    return curInviteSection == FriendsInviteTab.sent
        ? sentFriends
        : pendingFriends;
  }

  bool get activeHasMore {
    if (curSection == FriendsPrimaryTab.friends) {
      return friendsHasMore;
    }
    return curInviteSection == FriendsInviteTab.sent
        ? sentHasMore
        : pendingHasMore;
  }

  String? get activeNextCursor {
    if (curSection == FriendsPrimaryTab.friends) {
      return friendsNextCursor;
    }
    return curInviteSection == FriendsInviteTab.sent
        ? sentNextCursor
        : pendingNextCursor;
  }

  FriendsState copyWith({
    FriendsPrimaryTab? curSection,
    FriendsInviteTab? curInviteSection,
    FriendsStatus? status,
    List<FriendEntity>? friends,
    List<FriendEntity>? sentFriends,
    List<FriendEntity>? pendingFriends,
    List<FriendEntity>? filtered,
    Object? errorMessage = _friendsStateSentinel,
    Object? friendsNextCursor = _friendsStateSentinel,
    Object? sentNextCursor = _friendsStateSentinel,
    Object? pendingNextCursor = _friendsStateSentinel,
    String? searchQuery,
    bool? friendsHasMore,
    bool? sentHasMore,
    bool? pendingHasMore,
    bool? isLoadingMore,
    bool? isPerformingAction,
    Object? activeActionMssv = _friendsStateSentinel,
    Object? actionErrorMessage = _friendsStateSentinel,
    Object? actionSuccessMessage = _friendsStateSentinel,
  }) {
    return FriendsState(
      curSection: curSection ?? this.curSection,
      curInviteSection: curInviteSection ?? this.curInviteSection,
      status: status ?? this.status,
      friends: friends ?? this.friends,
      sentFriends: sentFriends ?? this.sentFriends,
      pendingFriends: pendingFriends ?? this.pendingFriends,
      filtered: filtered ?? this.filtered,
      errorMessage: identical(errorMessage, _friendsStateSentinel)
          ? this.errorMessage
          : errorMessage as String?,
      friendsNextCursor: identical(friendsNextCursor, _friendsStateSentinel)
          ? this.friendsNextCursor
          : friendsNextCursor as String?,
      sentNextCursor: identical(sentNextCursor, _friendsStateSentinel)
          ? this.sentNextCursor
          : sentNextCursor as String?,
      pendingNextCursor: identical(pendingNextCursor, _friendsStateSentinel)
          ? this.pendingNextCursor
          : pendingNextCursor as String?,
      searchQuery: searchQuery ?? this.searchQuery,
      friendsHasMore: friendsHasMore ?? this.friendsHasMore,
      sentHasMore: sentHasMore ?? this.sentHasMore,
      pendingHasMore: pendingHasMore ?? this.pendingHasMore,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      isPerformingAction: isPerformingAction ?? this.isPerformingAction,
      activeActionMssv: identical(activeActionMssv, _friendsStateSentinel)
          ? this.activeActionMssv
          : activeActionMssv as String?,
      actionErrorMessage: identical(actionErrorMessage, _friendsStateSentinel)
          ? this.actionErrorMessage
          : actionErrorMessage as String?,
      actionSuccessMessage:
          identical(actionSuccessMessage, _friendsStateSentinel)
          ? this.actionSuccessMessage
          : actionSuccessMessage as String?,
    );
  }

  @override
  List<Object?> get props => [
    curSection,
    curInviteSection,
    status,
    friends,
    sentFriends,
    pendingFriends,
    filtered,
    errorMessage,
    friendsNextCursor,
    sentNextCursor,
    pendingNextCursor,
    searchQuery,
    friendsHasMore,
    sentHasMore,
    pendingHasMore,
    isLoadingMore,
    isPerformingAction,
    activeActionMssv,
    actionErrorMessage,
    actionSuccessMessage,
  ];
}

const Object _friendsStateSentinel = Object();

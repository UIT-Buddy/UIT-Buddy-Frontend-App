import 'package:equatable/equatable.dart';
import 'package:uit_buddy_mobile/features/profile/presentation/bloc/your_friends_screen/friends_state.dart';

abstract class FriendsEvent extends Equatable {
  const FriendsEvent();

  @override
  List<Object?> get props => [];
}

class FriendsLoaded extends FriendsEvent {
  const FriendsLoaded();
}

class FriendsRefreshed extends FriendsEvent {
  const FriendsRefreshed();
}

class FriendsLoadMore extends FriendsEvent {
  const FriendsLoadMore();
}

class FriendsPrimaryTabChanged extends FriendsEvent {
  final FriendsPrimaryTab tab;
  const FriendsPrimaryTabChanged({required this.tab});

  @override
  List<Object?> get props => [tab];
}

class FriendsInviteTabChanged extends FriendsEvent {
  final FriendsInviteTab tab;
  const FriendsInviteTabChanged({required this.tab});

  @override
  List<Object?> get props => [tab];
}

class FriendsSearchChanged extends FriendsEvent {
  final String query;
  const FriendsSearchChanged({required this.query});

  @override
  List<Object?> get props => [query];
}

class FriendsToggleFriendRequest extends FriendsEvent {
  final String receiverMssv;
  const FriendsToggleFriendRequest({required this.receiverMssv});

  @override
  List<Object?> get props => [receiverMssv];
}

class FriendsUnfriend extends FriendsEvent {
  final String friendMssv;
  const FriendsUnfriend({required this.friendMssv});

  @override
  List<Object?> get props => [friendMssv];
}

class FriendsRespondToFriendRequest extends FriendsEvent {
  final String senderMssv;
  final String action;
  const FriendsRespondToFriendRequest({
    required this.senderMssv,
    required this.action,
  });

  @override
  List<Object?> get props => [senderMssv, action];
}

class FriendsFeedbackCleared extends FriendsEvent {
  const FriendsFeedbackCleared();
}

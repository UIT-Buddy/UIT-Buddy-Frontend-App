import 'package:equatable/equatable.dart';
import 'package:uit_buddy_mobile/features/social/domain/entities/post_entity.dart';
import 'package:uit_buddy_mobile/features/social/presentation/bloc/user_profile/user_profile_state.dart';

abstract class UserProfileEvent extends Equatable {
  const UserProfileEvent();

  @override
  List<Object?> get props => [];
}

class UserProfileStarted extends UserProfileEvent {
  const UserProfileStarted({required this.mssv});

  final String mssv;

  @override
  List<Object?> get props => [mssv];
}

class UserProfileFriendActionSubmitted extends UserProfileEvent {
  const UserProfileFriendActionSubmitted({required this.action});

  final UserProfileFriendAction action;

  @override
  List<Object?> get props => [action];
}

class UserProfileFeedbackCleared extends UserProfileEvent {
  const UserProfileFeedbackCleared();
}

class UserProfilePostsRefreshed extends UserProfileEvent {
  const UserProfilePostsRefreshed();
}

class UserProfilePostsLoadMore extends UserProfileEvent {
  const UserProfilePostsLoadMore();
}

class UserProfilePostLiked extends UserProfileEvent {
  const UserProfilePostLiked({required this.postId});

  final String postId;

  @override
  List<Object?> get props => [postId];
}

class UserProfilePostUpdated extends UserProfileEvent {
  const UserProfilePostUpdated({required this.updatedPost});

  final PostEntity updatedPost;

  @override
  List<Object?> get props => [updatedPost.id];
}

class UserProfilePostDeleted extends UserProfileEvent {
  const UserProfilePostDeleted({required this.postId});

  final String postId;

  @override
  List<Object?> get props => [postId];
}

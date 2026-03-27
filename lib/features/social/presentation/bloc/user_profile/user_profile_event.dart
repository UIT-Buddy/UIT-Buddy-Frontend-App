import 'package:equatable/equatable.dart';
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

import 'package:equatable/equatable.dart';
import 'package:uit_buddy_mobile/features/social/domain/entities/other_people_entity.dart';

enum UserProfileStatus { initial, loading, loaded, error }

enum UserProfileFriendAction {
  sendRequest,
  cancelRequest,
  acceptRequest,
  rejectRequest,
  unfriend,
}

class UserProfileState extends Equatable {
  const UserProfileState({
    this.status = UserProfileStatus.initial,
    this.user,
    this.errorMessage,
    this.isFriendActionLoading = false,
    this.activeFriendAction,
    this.actionErrorMessage,
    this.actionSuccessMessage,
  });

  final UserProfileStatus status;
  final OtherPeopleEntity? user;
  final String? errorMessage;
  final bool isFriendActionLoading;
  final UserProfileFriendAction? activeFriendAction;
  final String? actionErrorMessage;
  final String? actionSuccessMessage;

  UserProfileState copyWith({
    UserProfileStatus? status,
    OtherPeopleEntity? user,
    Object? errorMessage = _sentinel,
    bool? isFriendActionLoading,
    Object? activeFriendAction = _sentinel,
    Object? actionErrorMessage = _sentinel,
    Object? actionSuccessMessage = _sentinel,
  }) {
    return UserProfileState(
      status: status ?? this.status,
      user: user ?? this.user,
      errorMessage: identical(errorMessage, _sentinel)
          ? this.errorMessage
          : errorMessage as String?,
      isFriendActionLoading:
          isFriendActionLoading ?? this.isFriendActionLoading,
      activeFriendAction: identical(activeFriendAction, _sentinel)
          ? this.activeFriendAction
          : activeFriendAction as UserProfileFriendAction?,
      actionErrorMessage: identical(actionErrorMessage, _sentinel)
          ? this.actionErrorMessage
          : actionErrorMessage as String?,
      actionSuccessMessage: identical(actionSuccessMessage, _sentinel)
          ? this.actionSuccessMessage
          : actionSuccessMessage as String?,
    );
  }

  @override
  List<Object?> get props => [
    status,
    user,
    errorMessage,
    isFriendActionLoading,
    activeFriendAction,
    actionErrorMessage,
    actionSuccessMessage,
  ];
}

const Object _sentinel = Object();

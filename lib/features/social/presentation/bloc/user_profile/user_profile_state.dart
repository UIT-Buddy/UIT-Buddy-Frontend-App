import 'package:equatable/equatable.dart';
import 'package:uit_buddy_mobile/features/social/domain/entities/other_people_entity.dart';
import 'package:uit_buddy_mobile/features/social/domain/entities/post_entity.dart';

enum UserProfileStatus { initial, loading, loaded, error }

enum UserProfilePostsStatus { initial, loading, loaded, error }

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
    this.postsStatus = UserProfilePostsStatus.initial,
    this.posts = const [],
    this.postsErrorMessage,
    this.nextPostsPage,
    this.hasMorePosts = true,
    this.isLoadingMorePosts = false,
    this.isFriendActionLoading = false,
    this.activeFriendAction,
    this.actionErrorMessage,
    this.actionSuccessMessage,
  });

  final UserProfileStatus status;
  final OtherPeopleEntity? user;
  final String? errorMessage;
  final UserProfilePostsStatus postsStatus;
  final List<PostEntity> posts;
  final String? postsErrorMessage;
  final int? nextPostsPage;
  final bool hasMorePosts;
  final bool isLoadingMorePosts;
  final bool isFriendActionLoading;
  final UserProfileFriendAction? activeFriendAction;
  final String? actionErrorMessage;
  final String? actionSuccessMessage;

  UserProfileState copyWith({
    UserProfileStatus? status,
    OtherPeopleEntity? user,
    Object? errorMessage = _sentinel,
    UserProfilePostsStatus? postsStatus,
    List<PostEntity>? posts,
    Object? postsErrorMessage = _sentinel,
    Object? nextPostsPage = _sentinel,
    bool? hasMorePosts,
    bool? isLoadingMorePosts,
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
      postsStatus: postsStatus ?? this.postsStatus,
      posts: posts ?? this.posts,
      postsErrorMessage: identical(postsErrorMessage, _sentinel)
          ? this.postsErrorMessage
          : postsErrorMessage as String?,
      nextPostsPage: identical(nextPostsPage, _sentinel)
          ? this.nextPostsPage
          : nextPostsPage as int?,
      hasMorePosts: hasMorePosts ?? this.hasMorePosts,
      isLoadingMorePosts: isLoadingMorePosts ?? this.isLoadingMorePosts,
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
    postsStatus,
    posts,
    postsErrorMessage,
    nextPostsPage,
    hasMorePosts,
    isLoadingMorePosts,
    isFriendActionLoading,
    activeFriendAction,
    actionErrorMessage,
    actionSuccessMessage,
  ];
}

const Object _sentinel = Object();

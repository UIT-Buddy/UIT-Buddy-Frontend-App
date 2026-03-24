import 'package:equatable/equatable.dart';
import 'package:uit_buddy_mobile/features/social/domain/entities/post_entity.dart';
import 'package:uit_buddy_mobile/features/social/domain/entities/search_user_entity.dart';

class SocialSearchState extends Equatable {
  const SocialSearchState({
    this.query = '',
    this.isLoading = false,
    this.users = const [],
    this.posts = const [],
    this.usersError,
    this.postsError,
    this.isLoadingMoreUsers = false,
    this.isLoadingMorePosts = false,
    this.nextUsersPage,
    this.nextPostsPage,
    this.hasMoreUsers = false,
    this.hasMorePosts = false,
  });

  final String query;
  final bool isLoading;
  final List<SearchUserEntity> users;
  final List<PostEntity> posts;
  final String? usersError;
  final String? postsError;
  final bool isLoadingMoreUsers;
  final bool isLoadingMorePosts;
  final int? nextUsersPage;
  final int? nextPostsPage;
  final bool hasMoreUsers;
  final bool hasMorePosts;

  bool get hasAnyResults => users.isNotEmpty || posts.isNotEmpty;

  bool get hasGlobalError =>
      !isLoading && !hasAnyResults && usersError != null && postsError != null;

  SocialSearchState copyWith({
    String? query,
    bool? isLoading,
    List<SearchUserEntity>? users,
    List<PostEntity>? posts,
    Object? usersError = _sentinel,
    Object? postsError = _sentinel,
    bool? isLoadingMoreUsers,
    bool? isLoadingMorePosts,
    Object? nextUsersPage = _sentinel,
    Object? nextPostsPage = _sentinel,
    bool? hasMoreUsers,
    bool? hasMorePosts,
  }) {
    return SocialSearchState(
      query: query ?? this.query,
      isLoading: isLoading ?? this.isLoading,
      users: users ?? this.users,
      posts: posts ?? this.posts,
      usersError: identical(usersError, _sentinel)
          ? this.usersError
          : usersError as String?,
      postsError: identical(postsError, _sentinel)
          ? this.postsError
          : postsError as String?,
      isLoadingMoreUsers: isLoadingMoreUsers ?? this.isLoadingMoreUsers,
      isLoadingMorePosts: isLoadingMorePosts ?? this.isLoadingMorePosts,
      nextUsersPage: identical(nextUsersPage, _sentinel)
          ? this.nextUsersPage
          : nextUsersPage as int?,
      nextPostsPage: identical(nextPostsPage, _sentinel)
          ? this.nextPostsPage
          : nextPostsPage as int?,
      hasMoreUsers: hasMoreUsers ?? this.hasMoreUsers,
      hasMorePosts: hasMorePosts ?? this.hasMorePosts,
    );
  }

  @override
  List<Object?> get props => [
    query,
    isLoading,
    users,
    posts,
    usersError,
    postsError,
    isLoadingMoreUsers,
    isLoadingMorePosts,
    nextUsersPage,
    nextPostsPage,
    hasMoreUsers,
    hasMorePosts,
  ];
}

const Object _sentinel = Object();

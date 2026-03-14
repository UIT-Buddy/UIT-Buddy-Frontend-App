import 'package:equatable/equatable.dart';
import 'package:uit_buddy_mobile/features/profile/domain/entities/post_entity.dart';

enum YourPostsStatus { initial, loading, loaded, error }

class YourPostsState extends Equatable {
  final YourPostsStatus status;
  final List<PostEntity> posts;
  final List<PostEntity> filtered;
  final String searchQuery;
  final String? errorMessage;

  const YourPostsState({
    this.status = YourPostsStatus.initial,
    this.posts = const [],
    this.filtered = const [],
    this.searchQuery = '',
    this.errorMessage,
  });

  YourPostsState copyWith({
    YourPostsStatus? status,
    List<PostEntity>? posts,
    List<PostEntity>? filtered,
    String? searchQuery,
    String? errorMessage,
  }) {
    return YourPostsState(
      status: status ?? this.status,
      posts: posts ?? this.posts,
      filtered: filtered ?? this.filtered,
      searchQuery: searchQuery ?? this.searchQuery,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, posts, filtered, searchQuery, errorMessage];
}

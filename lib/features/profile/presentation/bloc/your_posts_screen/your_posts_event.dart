import 'package:equatable/equatable.dart';
import 'package:uit_buddy_mobile/features/profile/domain/entities/post_entity.dart';

abstract class YourPostsEvent extends Equatable {
  const YourPostsEvent();

  @override
  List<Object?> get props => [];
}

class YourPostsLoaded extends YourPostsEvent {
  const YourPostsLoaded();
}

class YourPostsRefreshed extends YourPostsEvent {
  const YourPostsRefreshed();
}

class YourPostsLoadMore extends YourPostsEvent {
  const YourPostsLoadMore();
}

class YourPostsSearchChanged extends YourPostsEvent {
  final String query;
  const YourPostsSearchChanged({required this.query});

  @override
  List<Object?> get props => [query];
}

class YourPostsPostLiked extends YourPostsEvent {
  final String postId;
  const YourPostsPostLiked({required this.postId});

  @override
  List<Object?> get props => [postId];
}

class YourPostsPostDeleted extends YourPostsEvent {
  final String postId;
  const YourPostsPostDeleted({required this.postId});

  @override
  List<Object?> get props => [postId];
}

class YourPostsPostUpdated extends YourPostsEvent {
  final PostEntity updatedPost;
  const YourPostsPostUpdated({required this.updatedPost});

  @override
  List<Object?> get props => [updatedPost];
}


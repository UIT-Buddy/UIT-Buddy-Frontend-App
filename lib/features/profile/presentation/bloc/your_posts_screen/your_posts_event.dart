import 'package:equatable/equatable.dart';

abstract class YourPostsEvent extends Equatable {
  const YourPostsEvent();

  @override
  List<Object?> get props => [];
}

class YourPostsLoaded extends YourPostsEvent {
  const YourPostsLoaded();
}

class YourPostsSearchChanged extends YourPostsEvent {
  final String query;
  const YourPostsSearchChanged({required this.query});

  @override
  List<Object?> get props => [query];
}

class YourPostsPostDeleted extends YourPostsEvent {
  final String postId;
  const YourPostsPostDeleted({required this.postId});

  @override
  List<Object?> get props => [postId];
}

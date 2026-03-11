import 'package:equatable/equatable.dart';

abstract class NewFeedEvent extends Equatable {
  const NewFeedEvent();

  @override
  List<Object?> get props => [];
}

class NewFeedStarted extends NewFeedEvent {
  const NewFeedStarted();
}

class NewFeedTabChanged extends NewFeedEvent {
  final int tabIndex;

  const NewFeedTabChanged({required this.tabIndex});

  @override
  List<Object?> get props => [tabIndex];
}

class NewFeedPostLiked extends NewFeedEvent {
  final String postId;

  const NewFeedPostLiked({required this.postId});

  @override
  List<Object?> get props => [postId];
}

class NewFeedRefreshed extends NewFeedEvent {
  const NewFeedRefreshed();
}

class NewFeedLoadMore extends NewFeedEvent {
  const NewFeedLoadMore();
}

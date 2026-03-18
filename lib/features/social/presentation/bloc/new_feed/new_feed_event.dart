import 'package:equatable/equatable.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uit_buddy_mobile/features/social/domain/entities/post_entity.dart';

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

class NewFeedPostSubmitted extends NewFeedEvent {
  final String title;
  final String? content;
  final List<XFile> images;
  final List<XFile> videos;

  const NewFeedPostSubmitted({
    required this.title,
    this.content,
    this.images = const [],
    this.videos = const [],
  });

  @override
  List<Object?> get props => [title, content];
}

class NewFeedPostDeleted extends NewFeedEvent {
  final String postId;

  const NewFeedPostDeleted({required this.postId});

  @override
  List<Object?> get props => [postId];
}

class NewFeedPostUpdated extends NewFeedEvent {
  final PostEntity updatedPost;

  const NewFeedPostUpdated({required this.updatedPost});

  @override
  List<Object?> get props => [updatedPost.id];
}

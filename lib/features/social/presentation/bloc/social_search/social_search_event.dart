import 'package:equatable/equatable.dart';

abstract class SocialSearchEvent extends Equatable {
  const SocialSearchEvent();

  @override
  List<Object?> get props => [];
}

class SocialSearchStarted extends SocialSearchEvent {
  const SocialSearchStarted({required this.query});

  final String query;

  @override
  List<Object?> get props => [query];
}

class SocialSearchSubmitted extends SocialSearchEvent {
  const SocialSearchSubmitted({required this.query});

  final String query;

  @override
  List<Object?> get props => [query];
}

class SocialSearchRetried extends SocialSearchEvent {
  const SocialSearchRetried();
}

class SocialSearchUsersLoadMore extends SocialSearchEvent {
  const SocialSearchUsersLoadMore();
}

class SocialSearchPostsLoadMore extends SocialSearchEvent {
  const SocialSearchPostsLoadMore();
}

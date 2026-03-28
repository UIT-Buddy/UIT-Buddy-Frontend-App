import 'package:equatable/equatable.dart';

abstract class UserSearchEvent extends Equatable {
  const UserSearchEvent();

  @override
  List<Object?> get props => [];
}

class UserSearchQueryChanged extends UserSearchEvent {
  final String query;

  const UserSearchQueryChanged({required this.query});

  @override
  List<Object?> get props => [query];
}

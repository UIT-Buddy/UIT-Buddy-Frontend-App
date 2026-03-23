import 'package:equatable/equatable.dart';

abstract class GroupEvent extends Equatable {
  const GroupEvent();

  @override
  List<Object?> get props => [];
}

class GroupStarted extends GroupEvent {
  const GroupStarted();
}

class GroupSearch extends GroupEvent {
  const GroupSearch(this.query);

  final String query;

  @override
  List<Object?> get props => [query];
}

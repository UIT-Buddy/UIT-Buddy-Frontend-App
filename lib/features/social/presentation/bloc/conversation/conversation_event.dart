import 'package:equatable/equatable.dart';

abstract class ConversationEvent extends Equatable {
  const ConversationEvent();

  @override
  List<Object?> get props => [];
}

class ConversationStarted extends ConversationEvent {
  const ConversationStarted();
}

class ConversationRefreshed extends ConversationEvent {
  const ConversationRefreshed();
}

class ConversationSearchChanged extends ConversationEvent {
  final String query;

  const ConversationSearchChanged({required this.query});

  @override
  List<Object?> get props => [query];
}

import 'package:equatable/equatable.dart';
import 'package:uit_buddy_mobile/core/realtime/chat_realtime_service.dart';

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

class ConversationOpened extends ConversationEvent {
  final String conversationId;

  const ConversationOpened({required this.conversationId});

  @override
  List<Object?> get props => [conversationId];
}

/// A new real-time message arrived from [ChatRealtimeService].
class ConversationNewMessageReceived extends ConversationEvent {
  const ConversationNewMessageReceived(this.info);

  final IncomingMessageInfo info;

  @override
  List<Object?> get props => [info];
}

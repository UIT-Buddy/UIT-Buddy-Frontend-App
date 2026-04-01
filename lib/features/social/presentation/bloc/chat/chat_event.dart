import 'package:equatable/equatable.dart';
import 'package:uit_buddy_mobile/features/social/domain/entities/message_entity.dart';

abstract class ChatEvent extends Equatable {
  const ChatEvent();

  @override
  List<Object?> get props => [];
}

class ChatStarted extends ChatEvent {
  final String receiverId;
  final bool isGroup;

  const ChatStarted({required this.receiverId, this.isGroup = false});

  @override
  List<Object?> get props => [receiverId, isGroup];
}

class ChatLoadMore extends ChatEvent {
  const ChatLoadMore();
}

class ChatSendText extends ChatEvent {
  final String text;

  const ChatSendText({required this.text});

  @override
  List<Object?> get props => [text];
}

class ChatEditMessage extends ChatEvent {
  final String messageId;
  final String text;
  final String receiverId;
  final bool isGroup;

  const ChatEditMessage({
    required this.messageId,
    required this.text,
    required this.receiverId,
    required this.isGroup,
  });

  @override
  List<Object?> get props => [messageId, text, receiverId, isGroup];
}

class ChatDeleteMessage extends ChatEvent {
  final String messageId;

  const ChatDeleteMessage({required this.messageId});

  @override
  List<Object?> get props => [messageId];
}

class ChatToggleEdit extends ChatEvent {
  final MessageEntity? message;

  const ChatToggleEdit({this.message});

  @override
  List<Object?> get props => [message];
}

/// A new real-time message arrived from [ChatRealtimeService].
class ChatNewMessageReceived extends ChatEvent {
  const ChatNewMessageReceived(this.message);

  final MessageEntity message;

  @override
  List<Object?> get props => [message];
}

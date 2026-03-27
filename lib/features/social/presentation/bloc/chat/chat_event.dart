import 'package:equatable/equatable.dart';

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

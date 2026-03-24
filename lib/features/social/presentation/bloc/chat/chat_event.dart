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

import 'package:equatable/equatable.dart';

abstract class AIChatEvent extends Equatable {
  const AIChatEvent();

  @override
  List<Object?> get props => [];
}

class AIChatStarted extends AIChatEvent {
  const AIChatStarted();
}

class AIChatMessageSubmitted extends AIChatEvent {
  final String message;

  const AIChatMessageSubmitted({required this.message});

  @override
  List<Object?> get props => [message];
}

class AIChatLoadMore extends AIChatEvent {
  const AIChatLoadMore();
}

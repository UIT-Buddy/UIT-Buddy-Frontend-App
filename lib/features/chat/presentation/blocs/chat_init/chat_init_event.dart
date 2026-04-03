import 'package:equatable/equatable.dart';

abstract class ChatInitEvent extends Equatable {
  const ChatInitEvent();

  @override
  List<Object?> get props => [];
}

class ChatInitRequested extends ChatInitEvent {
  const ChatInitRequested();
}

class ChatLoginRequested extends ChatInitEvent {
  final String uid;
  final String? name;

  const ChatLoginRequested({required this.uid, this.name});

  @override
  List<Object?> get props => [uid, name];
}

class ChatLogoutRequested extends ChatInitEvent {
  const ChatLogoutRequested();
}

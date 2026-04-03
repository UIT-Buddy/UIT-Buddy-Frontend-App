import 'package:equatable/equatable.dart';
import 'package:cometchat_chat_uikit/cometchat_chat_uikit.dart';

enum ChatInitStatus {
  initial,
  initializing,
  initialized,
  loggingIn,
  loggedIn,
  error,
}

class ChatInitState extends Equatable {
  final ChatInitStatus status;
  final User? currentUser;
  final String? errorMessage;

  const ChatInitState({
    this.status = ChatInitStatus.initial,
    this.currentUser,
    this.errorMessage,
  });

  ChatInitState copyWith({
    ChatInitStatus? status,
    User? currentUser,
    String? errorMessage,
  }) {
    return ChatInitState(
      status: status ?? this.status,
      currentUser: currentUser ?? this.currentUser,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, currentUser, errorMessage];
}

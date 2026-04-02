import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uit_buddy_mobile/features/chat/presentation/blocs/chat_init/chat_init_event.dart';
import 'package:uit_buddy_mobile/features/chat/presentation/blocs/chat_init/chat_init_state.dart';
import 'package:uit_buddy_mobile/features/chat/services/chat_service.dart';

class ChatInitBloc extends Bloc<ChatInitEvent, ChatInitState> {
  final ChatService _chatService;

  ChatInitBloc({required ChatService chatService})
      : _chatService = chatService,
        super(const ChatInitState()) {
    on<ChatInitRequested>(_onInitRequested);
    on<ChatLoginRequested>(_onLoginRequested);
    on<ChatLogoutRequested>(_onLogoutRequested);
  }

  Future<void> _onInitRequested(
    ChatInitRequested event,
    Emitter<ChatInitState> emit,
  ) async {
    emit(state.copyWith(status: ChatInitStatus.initializing));

    try {
      await _chatService.init();
      emit(state.copyWith(status: ChatInitStatus.initialized));
    } catch (e) {
      emit(state.copyWith(
        status: ChatInitStatus.error,
        errorMessage: e.toString(),
      ));
    }
  }

  Future<void> _onLoginRequested(
    ChatLoginRequested event,
    Emitter<ChatInitState> emit,
  ) async {
    emit(state.copyWith(status: ChatInitStatus.loggingIn));

    try {
      final success = await _chatService.login(event.uid, name: event.name);
      if (success) {
        emit(state.copyWith(
          status: ChatInitStatus.loggedIn,
          currentUser: _chatService.currentUser,
        ));
      } else {
        emit(state.copyWith(
          status: ChatInitStatus.error,
          errorMessage: 'Login failed',
        ));
      }
    } catch (e) {
      emit(state.copyWith(
        status: ChatInitStatus.error,
        errorMessage: e.toString(),
      ));
    }
  }

  Future<void> _onLogoutRequested(
    ChatLogoutRequested event,
    Emitter<ChatInitState> emit,
  ) async {
    await _chatService.logout();
    emit(const ChatInitState(status: ChatInitStatus.initial));
  }
}

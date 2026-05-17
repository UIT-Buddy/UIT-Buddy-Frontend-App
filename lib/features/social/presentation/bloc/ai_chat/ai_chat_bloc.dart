import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uit_buddy_mobile/features/social/domain/entities/ai_chat_entity.dart';
import 'package:uit_buddy_mobile/features/social/domain/usecases/ai_chat_send_message_usecase.dart';
import 'package:uit_buddy_mobile/features/social/presentation/bloc/ai_chat/ai_chat_event.dart';
import 'package:uit_buddy_mobile/features/social/presentation/bloc/ai_chat/ai_chat_state.dart';

class AIChatBloc extends Bloc<AIChatEvent, AIChatState> {
  final AIChatSendMessageUsecase sendMessageUsecase;

  AIChatBloc({required this.sendMessageUsecase}) : super(const AIChatState()) {
    on<AIChatStarted>(_onAIChatStarted);
    on<AIChatMessageSubmitted>(_onAiChatMessageSubmitted);
  }

  Future<void> _onAIChatStarted(
    AIChatStarted event,
    Emitter<AIChatState> emit,
  ) async {
    emit(state.copyWith(status: AIChatStatus.loading));

    try {
      // Simulate loading initial welcome message
      await Future.delayed(const Duration(milliseconds: 500));
      final messages = [
        AIChatEntity(
          id: DateTime.now().microsecondsSinceEpoch.toString(),
          message: 'Hi! I am your AI assistant. How can I help you today?',
          isUserMessage: false,
          timestamp: DateTime.now(),
        ),
      ];
      emit(state.copyWith(status: AIChatStatus.loaded, messages: messages));
    } catch (e) {
      emit(
        state.copyWith(
          status: AIChatStatus.error,
          errorMessage: 'Failed to load messages',
        ),
      );
    }
  }

  Future<void> _onAiChatMessageSubmitted(
    AIChatMessageSubmitted event,
    Emitter<AIChatState> emit,
  ) async {
    // 1. Add user message
    final userMessage = AIChatEntity(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      message: event.message,
      isUserMessage: true,
      timestamp: DateTime.now(),
    );
    emit(
      state.copyWith(
        messages: List.of(state.messages)..add(userMessage),
        status: AIChatStatus.submitting,
      ),
    );

    // 2. Call Usecase
    final result = await sendMessageUsecase(event.message);

    // 3. Handle response
    result.fold(
      (failure) {
        emit(
          state.copyWith(
            status: AIChatStatus.loaded,
            errorMessage: failure.message,
            messages: List.of(state.messages)
              ..add(
                AIChatEntity(
                  id: DateTime.now().microsecondsSinceEpoch.toString(),
                  message: 'Sorry, I encountered an error. Please try again.',
                  isUserMessage: false,
                  timestamp: DateTime.now(),
                ),
              ),
          ),
        );
      },
      (answer) {
        emit(
          state.copyWith(
            status: AIChatStatus.loaded,
            errorMessage: null,
            messages: List.of(state.messages)
              ..add(
                AIChatEntity(
                  id: DateTime.now().microsecondsSinceEpoch.toString(),
                  message: answer,
                  isUserMessage: false,
                  timestamp: DateTime.now(),
                ),
              ),
          ),
        );
      },
    );
  }
}

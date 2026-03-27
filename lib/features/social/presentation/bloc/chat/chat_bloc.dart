import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uit_buddy_mobile/features/social/domain/entities/message_entity.dart';
import 'package:uit_buddy_mobile/features/social/domain/usecases/get_messages_usecase.dart';
import 'package:uit_buddy_mobile/features/social/domain/usecases/send_text_message_usecase.dart';
import 'package:uit_buddy_mobile/features/social/presentation/bloc/chat/chat_event.dart';
import 'package:uit_buddy_mobile/features/social/presentation/bloc/chat/chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  ChatBloc({
    required GetMessagesUsecase getMessagesUsecase,
    required SendTextMessageUsecase sendTextMessageUsecase,
  }) : _getMessagesUsecase = getMessagesUsecase,
       _sendTextMessageUsecase = sendTextMessageUsecase,
       super(const ChatState()) {
    on<ChatStarted>(_onStarted);
    on<ChatLoadMore>(_onLoadMore);
    on<ChatSendText>(_onSendText);
  }

  final GetMessagesUsecase _getMessagesUsecase;
  final SendTextMessageUsecase _sendTextMessageUsecase;
  ChatStarted? _lastStartedEvent;

  Future<void> _onStarted(ChatStarted event, Emitter<ChatState> emit) async {
    emit(state.copyWith(status: ChatStatus.loading));

    final result = await _getMessagesUsecase(
      GetMessagesParams(receiverId: event.receiverId, isGroup: event.isGroup),
    );

    result.fold(
      (failure) => emit(
        state.copyWith(status: ChatStatus.error, errorMessage: failure.message),
      ),
      (messages) {
        final sorted = _sortOldestFirst(messages);
        emit(
          state.copyWith(
            status: ChatStatus.loaded,
            messages: sorted,
            hasMore: messages.length >= 30,
          ),
        );
      },
    );
  }

  Future<void> _onLoadMore(ChatLoadMore event, Emitter<ChatState> emit) async {
    if (!state.hasMore || state.isLoadingMore) return;

    emit(state.copyWith(isLoadingMore: true));

    final currentEvent = _lastStartedEvent;
    if (currentEvent == null) {
      emit(state.copyWith(isLoadingMore: false));
      return;
    }

    final result = await _getMessagesUsecase(
      GetMessagesParams(
        receiverId: currentEvent.receiverId,
        isGroup: currentEvent.isGroup,
      ),
    );

    result.fold((failure) => emit(state.copyWith(isLoadingMore: false)), (
      olderMessages,
    ) {
      if (olderMessages.isEmpty) {
        emit(state.copyWith(isLoadingMore: false, hasMore: false));
        return;
      }
      final merged = _dedupeById([
        ..._sortOldestFirst(olderMessages),
        ...state.messages,
      ]);
      emit(
        state.copyWith(
          isLoadingMore: false,
          hasMore: olderMessages.length >= 30,
          messages: merged,
        ),
      );
    });
  }

  Future<void> _onSendText(ChatSendText event, Emitter<ChatState> emit) async {
    final currentEvent = _lastStartedEvent;
    if (currentEvent == null) return;

    final result = await _sendTextMessageUsecase(
      SendTextMessageParams(
        receiverId: currentEvent.receiverId,
        isGroup: currentEvent.isGroup,
        text: event.text,
      ),
    );

    result.fold((failure) {}, (sentMessage) {
      final merged = _dedupeById([...state.messages, sentMessage]);
      emit(state.copyWith(messages: _sortOldestFirst(merged)));
    });
  }

  List<MessageEntity> _sortOldestFirst(List<MessageEntity> messages) {
    final copy = List<MessageEntity>.from(messages);
    copy.sort((a, b) {
      final at = a.sentAtRaw;
      final bt = b.sentAtRaw;
      if (at == null && bt == null) return 0;
      if (at == null) return -1;
      if (bt == null) return 1;
      return at.compareTo(bt);
    });
    return copy;
  }

  List<MessageEntity> _dedupeById(List<MessageEntity> messages) {
    final seen = <String>{};
    return messages.where((m) => seen.add(m.id)).toList();
  }

  @override
  void onEvent(ChatEvent event) {
    super.onEvent(event);
    if (event is ChatStarted) {
      _lastStartedEvent = event;
    }
  }
}

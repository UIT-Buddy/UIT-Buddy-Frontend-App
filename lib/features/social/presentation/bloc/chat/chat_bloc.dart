import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uit_buddy_mobile/features/social/domain/usecases/get_messages_usecase.dart';
import 'package:uit_buddy_mobile/features/social/presentation/bloc/chat/chat_event.dart';
import 'package:uit_buddy_mobile/features/social/presentation/bloc/chat/chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  ChatBloc({required GetMessagesUsecase getMessagesUsecase})
    : _getMessagesUsecase = getMessagesUsecase,
      super(const ChatState()) {
    on<ChatStarted>(_onStarted);
    on<ChatLoadMore>(_onLoadMore);
  }

  final GetMessagesUsecase _getMessagesUsecase;

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
        // SDK returns oldest-first; we reverse to display newest at bottom.
        final sorted = messages.reversed.toList();
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

    // The same MessagesRequest object advances its cursor on each fetchPrevious call.
    // We call the usecase again — the datasource reuses the same request object,
    // so it returns the next (older) batch.
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
      final sorted = olderMessages.reversed.toList();
      emit(
        state.copyWith(
          isLoadingMore: false,
          hasMore: olderMessages.length >= 30,
          messages: [...sorted, ...state.messages],
        ),
      );
    });
  }

  ChatStarted? _lastStartedEvent;

  @override
  void onEvent(ChatEvent event) {
    super.onEvent(event);
    if (event is ChatStarted) {
      _lastStartedEvent = event;
    }
  }
}

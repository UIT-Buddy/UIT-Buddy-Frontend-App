import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uit_buddy_mobile/core/realtime/chat_realtime_service.dart';
import 'package:uit_buddy_mobile/core/usecase/usecase_interface.dart';
import 'package:uit_buddy_mobile/features/social/domain/entities/conversation_entity.dart';
import 'package:uit_buddy_mobile/features/social/domain/usecases/get_conversations_usecase.dart';
import 'package:uit_buddy_mobile/features/social/presentation/bloc/conversation/conversation_event.dart';
import 'package:uit_buddy_mobile/features/social/presentation/bloc/conversation/conversation_state.dart';

class ConversationBloc extends Bloc<ConversationEvent, ConversationState> {
  ConversationBloc({required GetConversationsUsecase getConversationsUsecase})
    : _getConversationsUsecase = getConversationsUsecase,
      super(const ConversationState()) {
    on<ConversationStarted>(_onStarted);
    on<ConversationRefreshed>(_onRefreshed);
    on<ConversationSearchChanged>(_onSearchChanged);
    on<ConversationOpened>(_onOpened);
    on<ConversationNewMessageReceived>(_onNewMessageReceived);

    // Subscribe to real-time messages from ChatRealtimeService
    _realtimeSubscription = ChatRealtimeService.instance.messageStream.listen(
      (info) => add(ConversationNewMessageReceived(info)),
    );
  }

  final GetConversationsUsecase _getConversationsUsecase;
  StreamSubscription<IncomingMessageInfo>? _realtimeSubscription;

  Future<void> _onStarted(
    ConversationStarted event,
    Emitter<ConversationState> emit,
  ) async {
    _getConversationsUsecase.reset();
    emit(state.copyWith(status: ConversationStatus.loading));
    await _fetchConversations(emit);
  }

  Future<void> _onRefreshed(
    ConversationRefreshed event,
    Emitter<ConversationState> emit,
  ) async {
    _getConversationsUsecase.reset();
    emit(state.copyWith(status: ConversationStatus.loading, searchQuery: ''));
    await _fetchConversations(emit);
  }

  void _onSearchChanged(
    ConversationSearchChanged event,
    Emitter<ConversationState> emit,
  ) {
    final query = event.query.trim().toLowerCase();
    final filtered = query.isEmpty
        ? state.conversations
        : state.conversations
              .where((c) => c.name.toLowerCase().contains(query))
              .toList();

    emit(
      state.copyWith(searchQuery: event.query, filteredConversations: filtered),
    );
  }

  void _onOpened(ConversationOpened event, Emitter<ConversationState> emit) {
    final updatedConversations = state.conversations
        .map(
          (conversation) => conversation.id == event.conversationId
              ? conversation.copyWith(unreadCount: 0)
              : conversation,
        )
        .toList();

    emit(
      state.copyWith(
        conversations: updatedConversations,
        filteredConversations: _applySearch(
          updatedConversations,
          state.searchQuery,
        ),
      ),
    );
  }

  void _onNewMessageReceived(
    ConversationNewMessageReceived event,
    Emitter<ConversationState> emit,
  ) {
    final info = event.info;

    // Find the conversation that received the message
    final idx = state.conversations.indexWhere(
      (c) =>
          c.id == info.conversationId ||
          c.conversationWith == info.conversationId,
    );

    if (idx == -1) {
      // New conversation not in list — refresh the whole list
      add(const ConversationRefreshed());
      return;
    }

    // Update existing conversation in place
    final updated = List<ConversationEntity>.from(state.conversations);
    final conv = updated[idx];
    updated[idx] = conv.copyWith(
      lastMessage: info.message.content,
      time: info.message.time,
      unreadCount: conv.unreadCount + 1,
    );

    // Move to top of list
    final item = updated.removeAt(idx);
    updated.insert(0, item);

    emit(
      state.copyWith(
        conversations: updated,
        filteredConversations: _applySearch(updated, state.searchQuery),
      ),
    );
  }

  Future<void> _fetchConversations(Emitter<ConversationState> emit) async {
    final result = await _getConversationsUsecase(const NoParams());

    result.fold(
      (failure) => emit(
        state.copyWith(
          status: ConversationStatus.error,
          errorMessage: failure.message,
        ),
      ),
      (conversations) => emit(
        state.copyWith(
          status: ConversationStatus.loaded,
          conversations: conversations,
          filteredConversations: _applySearch(conversations, state.searchQuery),
        ),
      ),
    );
  }

  List<ConversationEntity> _applySearch(
    List<ConversationEntity> conversations,
    String query,
  ) {
    debugPrint(
      'Applying search: $query length conversations: ${conversations.length}',
    );
    final q = query.trim().toLowerCase();
    if (q.isEmpty) return conversations;
    return conversations
        .where((c) => c.name.toLowerCase().contains(q))
        .toList();
  }

  @override
  Future<void> close() async {
    await _realtimeSubscription?.cancel();
    return super.close();
  }
}

import 'package:flutter_bloc/flutter_bloc.dart';
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
  }

  final GetConversationsUsecase _getConversationsUsecase;

  Future<void> _onStarted(
    ConversationStarted event,
    Emitter<ConversationState> emit,
  ) async {
    emit(state.copyWith(status: ConversationStatus.loading));
    await _fetchConversations(emit);
  }

  Future<void> _onRefreshed(
    ConversationRefreshed event,
    Emitter<ConversationState> emit,
  ) async {
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
      state.copyWith(
        searchQuery: event.query,
        filteredConversations: filtered,
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
    final q = query.trim().toLowerCase();
    if (q.isEmpty) return conversations;
    return conversations
        .where((c) => c.name.toLowerCase().contains(q))
        .toList();
  }
}

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:uit_buddy_mobile/features/social/domain/entities/conversation_entity.dart';

part 'conversation_state.freezed.dart';

enum ConversationStatus { initial, loading, loaded, error }

@freezed
abstract class ConversationState with _$ConversationState {
  const factory ConversationState({
    @Default(ConversationStatus.initial) ConversationStatus status,
    @Default([]) List<ConversationEntity> conversations,
    @Default([]) List<ConversationEntity> filteredConversations,
    @Default('') String searchQuery,
    String? errorMessage,
  }) = _ConversationState;
}

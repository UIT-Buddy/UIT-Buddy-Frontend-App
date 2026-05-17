import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:uit_buddy_mobile/features/social/domain/entities/ai_chat_entity.dart';

part 'ai_chat_state.freezed.dart';

enum AIChatStatus { initial, loading, loaded, submitting, error }

@freezed
abstract class AIChatState with _$AIChatState {
  const factory AIChatState({
    @Default(AIChatStatus.initial) AIChatStatus status,
    @Default([]) List<AIChatEntity> messages,
    String? errorMessage,
    @Default(false) bool isLoading,
    @Default(false) bool isSubmittingPost,
  }) = _AIChatState;
}

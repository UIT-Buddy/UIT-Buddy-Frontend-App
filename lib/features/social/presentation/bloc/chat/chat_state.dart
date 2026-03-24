import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:uit_buddy_mobile/features/social/domain/entities/message_entity.dart';

part 'chat_state.freezed.dart';

enum ChatStatus { initial, loading, loaded, error }

@freezed
abstract class ChatState with _$ChatState {
  const factory ChatState({
    @Default(ChatStatus.initial) ChatStatus status,
    @Default([]) List<MessageEntity> messages,
    @Default(true) bool hasMore,
    @Default(false) bool isLoadingMore,
    String? errorMessage,
  }) = _ChatState;
}

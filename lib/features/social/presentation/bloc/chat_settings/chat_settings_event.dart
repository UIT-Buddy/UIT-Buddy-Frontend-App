import 'package:equatable/equatable.dart';
import 'package:uit_buddy_mobile/features/social/domain/entities/conversation_entity.dart';

abstract class ChatSettingsEvent extends Equatable {
  const ChatSettingsEvent();

  @override
  List<Object?> get props => [];
}

class ChatSettingsStarted extends ChatSettingsEvent {
  const ChatSettingsStarted({required this.conversation});

  final ConversationEntity conversation;

  @override
  List<Object?> get props => [conversation.id];
}

class ChatSettingsNotificationToggled extends ChatSettingsEvent {
  const ChatSettingsNotificationToggled();
}

class ChatSettingsMediaTabChanged extends ChatSettingsEvent {
  const ChatSettingsMediaTabChanged({required this.tabIndex});

  final int tabIndex;

  @override
  List<Object?> get props => [tabIndex];
}

class ChatSettingsNicknameUpdated extends ChatSettingsEvent {
  const ChatSettingsNicknameUpdated({
    required this.userId,
    required this.nickname,
  });

  final String userId;
  final String nickname;

  @override
  List<Object?> get props => [userId, nickname];
}

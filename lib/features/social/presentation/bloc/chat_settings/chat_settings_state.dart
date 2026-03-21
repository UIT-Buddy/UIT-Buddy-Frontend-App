import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:uit_buddy_mobile/features/social/domain/entities/chat_member_entity.dart';
import 'package:uit_buddy_mobile/features/social/domain/entities/shared_media_entity.dart';

part 'chat_settings_state.freezed.dart';

enum ChatSettingsStatus { initial, loading, loaded }

enum ChatSettingsMediaTab { media, files }

@freezed
abstract class ChatSettingsState with _$ChatSettingsState {
  const factory ChatSettingsState({
    @Default(ChatSettingsStatus.initial) ChatSettingsStatus status,
    @Default([]) List<ChatMemberEntity> members,
    @Default([]) List<SharedMediaEntity> sharedMedia,
    @Default([]) List<SharedMediaEntity> sharedFiles,
    @Default({}) Map<String, String> nicknames,
    @Default(false) bool isMuted,
    @Default(ChatSettingsMediaTab.media) ChatSettingsMediaTab selectedMediaTab,
  }) = _ChatSettingsState;
}

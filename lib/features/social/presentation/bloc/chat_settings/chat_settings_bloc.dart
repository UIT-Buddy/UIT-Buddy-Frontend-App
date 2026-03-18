import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uit_buddy_mobile/features/social/data/mock/mock_chat_settings.dart';
import 'package:uit_buddy_mobile/features/social/domain/entities/shared_media_entity.dart';
import 'package:uit_buddy_mobile/features/social/presentation/bloc/chat_settings/chat_settings_event.dart';
import 'package:uit_buddy_mobile/features/social/presentation/bloc/chat_settings/chat_settings_state.dart';

class ChatSettingsBloc extends Bloc<ChatSettingsEvent, ChatSettingsState> {
  ChatSettingsBloc() : super(const ChatSettingsState()) {
    on<ChatSettingsStarted>(_onStarted);
    on<ChatSettingsNotificationToggled>(_onNotificationToggled);
    on<ChatSettingsMediaTabChanged>(_onMediaTabChanged);
    on<ChatSettingsNicknameUpdated>(_onNicknameUpdated);
  }

  Future<void> _onStarted(
    ChatSettingsStarted event,
    Emitter<ChatSettingsState> emit,
  ) async {
    emit(state.copyWith(status: ChatSettingsStatus.loading));

    await Future.delayed(const Duration(milliseconds: 300));

    final allMedia = getMockSharedMedia(event.conversation.id);
    final media = allMedia
        .where((m) => m.type == SharedMediaType.image)
        .toList();
    final files = allMedia
        .where((m) => m.type == SharedMediaType.file)
        .toList();
    final members = getMockMembers(event.conversation.id);
    final nicknames = getMockNicknames(event.conversation.id);

    emit(
      state.copyWith(
        status: ChatSettingsStatus.loaded,
        members: members,
        sharedMedia: media,
        sharedFiles: files,
        nicknames: nicknames,
      ),
    );
  }

  void _onNotificationToggled(
    ChatSettingsNotificationToggled event,
    Emitter<ChatSettingsState> emit,
  ) {
    emit(state.copyWith(isMuted: !state.isMuted));
  }

  void _onMediaTabChanged(
    ChatSettingsMediaTabChanged event,
    Emitter<ChatSettingsState> emit,
  ) {
    final tab = event.tabIndex == 0
        ? ChatSettingsMediaTab.media
        : ChatSettingsMediaTab.files;
    emit(state.copyWith(selectedMediaTab: tab));
  }

  void _onNicknameUpdated(
    ChatSettingsNicknameUpdated event,
    Emitter<ChatSettingsState> emit,
  ) {
    final updated = Map<String, String>.from(state.nicknames);
    updated[event.userId] = event.nickname;
    emit(state.copyWith(nicknames: updated));
  }
}

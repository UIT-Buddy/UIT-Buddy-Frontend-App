import 'dart:async';

import 'package:cometchat_sdk/cometchat_sdk.dart';
import 'package:flutter/material.dart';
import 'package:uit_buddy_mobile/features/social/data/datasources/chat_datasource_interface.dart';
import 'package:uit_buddy_mobile/features/social/domain/entities/message_entity.dart';

class ChatDatasourceImpl implements ChatDatasourceInterface {
  MessagesRequest? _userRequest;
  MessagesRequest? _groupRequest;

  String? _currentUid;
  String? _currentGuid;
  String? _loggedInUid;

  @override
  Future<List<MessageEntity>> getMessages({
    required String uid,
    int limit = 30,
  }) async {
    _loggedInUid ??= await _fetchLoggedInUid();

    if (_currentUid != uid) {
      _currentUid = uid;
      _userRequest = null;
    }

    _userRequest ??=
        (MessagesRequestBuilder()
              ..uid = uid
              ..limit = limit)
            .build();

    return _fetchMessages(_userRequest!);
  }

  @override
  Future<List<MessageEntity>> getGroupMessages({
    required String guid,
    int limit = 30,
  }) async {
    _loggedInUid ??= await _fetchLoggedInUid();

    if (_currentGuid != guid) {
      _currentGuid = guid;
      _groupRequest = null;
    }

    _groupRequest ??=
        (MessagesRequestBuilder()
              ..guid = guid
              ..limit = limit)
            .build();

    return _fetchMessages(_groupRequest!);
  }

  @override
  void reset() {
    _userRequest = null;
    _groupRequest = null;
    _currentUid = null;
    _currentGuid = null;
  }

  Future<List<MessageEntity>> _fetchMessages(MessagesRequest request) {
    final completer = Completer<List<MessageEntity>>();

    request.fetchPrevious(
      onSuccess: (List<BaseMessage> messages) {
        final entities = messages
            .map((m) => _mapToEntity(m, _loggedInUid ?? ''))
            .toList();
        completer.complete(entities);
      },
      onError: (CometChatException e) {
        debugPrint('ChatDatasource fetchPrevious error: ${e.message}');
        completer.completeError(Exception(e.message));
      },
    );

    return completer.future;
  }

  Future<String> _fetchLoggedInUid() async {
    final completer = Completer<String>();
    final user = await CometChat.getLoggedInUser();
    completer.complete(user?.uid ?? '');
    return completer.future;
  }

  MessageEntity _mapToEntity(BaseMessage message, String loggedInUid) {
    final isMine = message.sender?.uid == loggedInUid;
    final sentAt = message.sentAt;
    final time = _formatTime(sentAt);

    String content;
    MessageType type;

    if (message is TextMessage) {
      content = message.text;
      type = MessageType.text;
    } else if (message is MediaMessage) {
      type = MessageType.image;
      content = switch (message.type) {
        CometChatMessageType.image => '📷 Hình ảnh',
        CometChatMessageType.video => '🎥 Video',
        CometChatMessageType.audio => '🎵 Âm thanh',
        CometChatMessageType.file => '📎 Tệp đính kèm',
        _ => 'Đã gửi một tệp',
      };
    } else {
      content = 'Tin nhắn hệ thống';
      type = MessageType.system;
    }

    return MessageEntity(
      id: message.id.toString(),
      senderId: message.sender?.uid ?? '',
      senderName: message.sender?.name ?? '',
      content: content,
      time: time,
      isMine: isMine,
      type: type,
      sentAtRaw: sentAt,
    );
  }

  String _formatTime(DateTime? sentAt) {
    if (sentAt == null) return '';
    final hour = sentAt.hour.toString().padLeft(2, '0');
    final minute = sentAt.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }
}

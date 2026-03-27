import 'dart:async';

import 'package:cometchat_sdk/cometchat_sdk.dart';
import 'package:flutter/material.dart';
import 'package:uit_buddy_mobile/features/social/data/datasources/conversation_datasource_interface.dart';
import 'package:uit_buddy_mobile/features/social/domain/entities/conversation_entity.dart';

class ConversationDatasourceImpl implements ConversationDatasourceInterface {
  ConversationsRequest? _request;

  ConversationsRequest _buildRequest({int limit = 50}) =>
      (ConversationsRequestBuilder()..limit = limit).build();

  @override
  Future<List<ConversationEntity>> getConversations({int limit = 50}) {
    _request ??= _buildRequest(limit: limit);

    final completer = Completer<List<ConversationEntity>>();

    _request!.fetchNext(
      onSuccess: (List<Conversation> conversations) {
        completer.complete(conversations.map(_mapToEntity).toList());
      },
      onError: (CometChatException e) {
        debugPrint('ConversationDatasource fetchNext error: ${e.message}');
        completer.completeError(Exception(e.message));
      },
    );

    return completer.future;
  }

  @override
  void reset() {
    _request = null;
  }

  ConversationEntity _mapToEntity(Conversation conversation) {
    final isGroup =
        conversation.conversationType == CometChatConversationType.group;
    final conversationWith = conversation.conversationWith;

    String name = '';
    String avatarUrl = '';
    bool isOnline = false;

    if (conversationWith is User) {
      name = conversationWith.name;
      avatarUrl = conversationWith.avatar ?? '';
      isOnline = conversationWith.status == CometChatUserStatus.online;
    } else if (conversationWith is Group) {
      name = conversationWith.name;
      avatarUrl = conversationWith.icon ?? '';
    }

    return ConversationEntity(
      id: conversation.conversationId ?? '',
      name: name,
      avatarUrl: avatarUrl,
      lastMessage: _formatLastMessage(conversation.lastMessage),
      time: _formatTime(conversation.lastMessage?.sentAt),
      unreadCount: conversation.unreadMessageCount ?? 0,
      isGroup: isGroup,
      isOnline: isOnline,
      conversationType: conversation.conversationType,
    );
  }

  String _formatLastMessage(BaseMessage? message) {
    if (message == null) return '';

    if (message is TextMessage) {
      return message.text;
    } else if (message is MediaMessage) {
      return switch (message.type) {
        CometChatMessageType.image => '📷 Hình ảnh',
        CometChatMessageType.video => '🎥 Video',
        CometChatMessageType.audio => '🎵 Âm thanh',
        CometChatMessageType.file => '📎 Tệp đính kèm',
        _ => 'Đã gửi một tệp',
      };
    }

    return 'Tin nhắn mới';
  }

  String _formatTime(DateTime? sentAt) {
    if (sentAt == null) return '';

    final now = DateTime.now();
    final diff = now.difference(sentAt);

    if (diff.inDays == 0) {
      final hour = sentAt.hour.toString().padLeft(2, '0');
      final minute = sentAt.minute.toString().padLeft(2, '0');
      return '$hour:$minute';
    } else if (diff.inDays == 1) {
      return 'Hôm qua';
    } else if (diff.inDays < 7) {
      const weekdays = ['T2', 'T3', 'T4', 'T5', 'T6', 'T7', 'CN'];
      return weekdays[sentAt.weekday - 1];
    } else {
      final day = sentAt.day.toString().padLeft(2, '0');
      final month = sentAt.month.toString().padLeft(2, '0');
      return '$day/$month';
    }
  }
}

import 'dart:async';

import 'package:cometchat_sdk/cometchat_sdk.dart';
import 'package:flutter/widgets.dart';
import 'package:uit_buddy_mobile/features/social/domain/entities/message_entity.dart';

/// Holds information about an incoming real-time message from CometChat.
class IncomingMessageInfo {
  const IncomingMessageInfo({
    required this.message,
    required this.conversationId,
    required this.isGroup,
    required this.senderName,
  });

  final MessageEntity message;
  final String conversationId;
  final bool isGroup;
  final String senderName;
}

/// Central service that registers the CometChat [MessageListener] once
/// and broadcasts incoming messages to subscribers via [messageStream].
///
/// Use [ChatRealtimeService.instance] to access the singleton.
class ChatRealtimeService with WidgetsBindingObserver {
  ChatRealtimeService._();

  static final ChatRealtimeService instance = ChatRealtimeService._();

  static const _listenerId = '__chat_realtime_listener__';

  final _messageController = StreamController<IncomingMessageInfo>.broadcast();
  Stream<IncomingMessageInfo> get messageStream => _messageController.stream;

  String? _currentConversationId;
  String? get currentConversationId => _currentConversationId;

  String _loggedInUid = '';
  bool _isInitialized = false;

  /// Initializes the service — registers the CometChat MessageListener.
  /// Safe to call multiple times (idempotent).
  void init() {
    if (_isInitialized) return;
    _isInitialized = true;

    WidgetsBinding.instance.addObserver(this);
    _fetchLoggedInUid();

    CometChat.addMessageListener(
      _listenerId,
      _RealtimeListener(onText: _onTextMessage, onMedia: _onMediaMessage),
    );
  }

  void setCurrentConversation(String? id) {
    _currentConversationId = id;
  }

  bool get isAppInForeground {
    final state = WidgetsBinding.instance.lifecycleState;
    return state == AppLifecycleState.resumed;
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {}

  Future<void> _fetchLoggedInUid() async {
    final user = await CometChat.getLoggedInUser();
    _loggedInUid = user?.uid ?? '';
  }

  void _onTextMessage(TextMessage message) {
    final senderUid = message.sender?.uid ?? '';
    final isGroup = message.receiverType == CometChatConversationType.group;
    _emit(
      senderUid: senderUid,
      receiverUid: message.receiverUid,
      isGroup: isGroup,
      content: message.text,
      senderName: message.sender?.name ?? 'Unknown',
      sentAt: message.sentAt,
    );
  }

  void _onMediaMessage(MediaMessage message) {
    final senderUid = message.sender?.uid ?? '';
    final isGroup = message.receiverType == CometChatConversationType.group;
    final content = switch (message.type) {
      CometChatMessageType.image => '📷 Hình ảnh',
      CometChatMessageType.video => '🎥 Video',
      CometChatMessageType.audio => '🎵 Âm thanh',
      CometChatMessageType.file => '📎 Tệp đính kèm',
      _ => 'Đã gửi một tệp',
    };
    _emit(
      senderUid: senderUid,
      receiverUid: message.receiverUid,
      isGroup: isGroup,
      content: content,
      senderName: message.sender?.name ?? 'Unknown',
      sentAt: message.sentAt,
    );
  }

  void _emit({
    required String senderUid,
    required String receiverUid,
    required bool isGroup,
    required String content,
    required String senderName,
    DateTime? sentAt,
  }) {
    final safeSenderUid = senderUid.isEmpty ? _loggedInUid : senderUid;
    if (safeSenderUid == _loggedInUid) return;

    final conversationId = isGroup ? receiverUid : safeSenderUid;
    final time = _formatTime(sentAt);

    final entity = MessageEntity(
      id: '${sentAt?.millisecondsSinceEpoch ?? DateTime.now().millisecondsSinceEpoch}',
      senderId: safeSenderUid,
      senderName: senderName,
      content: content,
      time: time,
      isMine: false,
      type: MessageType.text,
      sentAtRaw: sentAt,
      receiverId: receiverUid,
      isGroup: isGroup,
    );

    _messageController.add(
      IncomingMessageInfo(
        message: entity,
        conversationId: conversationId,
        isGroup: isGroup,
        senderName: senderName,
      ),
    );
  }

  String _formatTime(DateTime? sentAt) {
    if (sentAt == null) return '';
    final hour = sentAt.hour.toString().padLeft(2, '0');
    final minute = sentAt.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    CometChat.removeMessageListener(_listenerId);
    _messageController.close();
  }
}

/// Internal [MessageListener] mixin class that bridges CometChat callbacks.
class _RealtimeListener extends Object with MessageListener {
  _RealtimeListener({
    required void Function(TextMessage) onText,
    required void Function(MediaMessage) onMedia,
  }) : _onText = onText,
       _onMedia = onMedia;

  final void Function(TextMessage) _onText;
  final void Function(MediaMessage) _onMedia;

  @override
  void onTextMessageReceived(TextMessage message) => _onText(message);

  @override
  void onMediaMessageReceived(MediaMessage message) => _onMedia(message);
}

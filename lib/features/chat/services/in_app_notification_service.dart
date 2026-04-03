import 'package:bot_toast/bot_toast.dart';
import 'package:cometchat_chat_uikit/cometchat_chat_uikit.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:uit_buddy_mobile/app/router/app_router_keys.dart';
import 'package:uit_buddy_mobile/app/router/route_name.dart';
import 'package:uit_buddy_mobile/core/theme/app_color.dart';

class InAppNotificationService {
  static final InAppNotificationService _instance = InAppNotificationService._internal();
  factory InAppNotificationService() => _instance;
  InAppNotificationService._internal();

  static const String _listenerId = 'InAppNotificationListener';

  /// Start listening for CometChat message events. Call after ChatService.login().
  void startListening() {
    CometChatMessageEvents.addMessagesListener(_listenerId, _MessageEventListener(this));
  }

  /// Stop listening. Call on logout.
  void stopListening() {
    CometChatMessageEvents.removeMessagesListener(_listenerId);
  }

  void _onMessageReceived(BaseMessage message) {
    // Skip if message is from self
    if (message.sender?.uid == CometChatUIKit.loggedInUser?.uid) return;
    _showToast(message);
  }

  void _showToast(BaseMessage message) {
    final sender = message.sender;
    String title = sender?.name ?? 'New Message';
    String body = _getMessagePreview(message);

    BotToast.showCustomNotification(
      onlyOne: true,
      crossPage: false,
      duration: const Duration(seconds: 4),
      toastBuilder: (cancelFunc) => _InAppToast(
        avatarUrl: sender?.avatar,
        title: title,
        body: body,
        onTap: () {
          cancelFunc();
          _navigateToConversation(message);
        },
        onDismiss: cancelFunc,
      ),
    );
  }

  void _navigateToConversation(BaseMessage message) {
    final isUserMessage = message.receiverType == ReceiverTypeConstants.user;
    User? user;
    Group? group;

    if (isUserMessage) {
      final receiver = message.receiver as User?;
      user = message.sender?.uid == CometChatUIKit.loggedInUser?.uid
          ? receiver
          : message.sender;
    } else {
      group = message.receiver as Group?;
    }

    rootNavigatorKey.currentContext?.push(
      RouteName.chatConversation,
      extra: {'user': user, 'group': group},
    );
  }

  String _getMessagePreview(BaseMessage message) {
    if (message is TextMessage) {
      return message.text.length > 60
          ? '${message.text.substring(0, 60)}...'
          : message.text;
    } else if (message is MediaMessage) {
      return '📎 ${message.attachment?.fileName ?? 'Media'}';
    } else if (message is CustomMessage) {
      return 'Custom message';
    }
    return 'New message';
  }
}

class _MessageEventListener with CometChatMessageEventListener {
  final InAppNotificationService _service;
  _MessageEventListener(this._service);

  @override
  void onTextMessageReceived(TextMessage textMessage) {
    _service._onMessageReceived(textMessage);
  }

  @override
  void onMediaMessageReceived(MediaMessage mediaMessage) {
    _service._onMessageReceived(mediaMessage);
  }

  @override
  void onCustomMessageReceived(CustomMessage customMessage) {
    _service._onMessageReceived(customMessage);
  }
}

class _InAppToast extends StatelessWidget {
  final String? avatarUrl;
  final String title;
  final String body;
  final VoidCallback onTap;
  final VoidCallback onDismiss;

  const _InAppToast({
    this.avatarUrl,
    required this.title,
    required this.body,
    required this.onTap,
    required this.onDismiss,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      onVerticalDragEnd: (details) {
        if (details.primaryVelocity != null && details.primaryVelocity! > 100) {
          onDismiss();
        }
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          color: AppColor.primaryText,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.15),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                _buildAvatar(),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        body,
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.8),
                          fontSize: 13,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: Icon(
                    Icons.close,
                    color: Colors.white.withValues(alpha: 0.7),
                    size: 20,
                  ),
                  onPressed: onDismiss,
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAvatar() {
    if (avatarUrl != null && avatarUrl!.isNotEmpty) {
      return CircleAvatar(
        radius: 20,
        backgroundImage: NetworkImage(avatarUrl!),
        backgroundColor: AppColor.primaryBlue,
      );
    }
    return CircleAvatar(
      radius: 20,
      backgroundColor: AppColor.primaryBlue,
      child: Text(
        title.isNotEmpty ? title[0].toUpperCase() : '?',
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 16,
        ),
      ),
    );
  }
}

import 'package:cometchat_chat_uikit/cometchat_chat_uikit.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:uit_buddy_mobile/features/chat/presentation/theme/chat_theme.dart';

class ChatConversationScreen extends StatelessWidget {
  final User? user;
  final Group? group;
  final BaseMessage? message;

  const ChatConversationScreen({
    super.key,
    this.user,
    this.group,
    this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _buildAppBar(context),
      body: Column(
        children: [
          Expanded(child: _buildMessageList(context)),
          _buildComposer(context),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return CometChatMessageHeader(
      user: user,
      group: group,
      onBack: () => context.pop(),
      messageHeaderStyle: ChatTheme.messageHeaderStyle,
    );
  }

  Widget _buildMessageList(BuildContext context) {
    if (user != null && user!.blockedByMe == true) {
      return _buildBlockedView(context);
    }
    if (group != null &&
        (group!.hasJoined == false || group!.isBannedFromGroup == true)) {
      return _buildKickedView(context);
    }

    return CometChatMessageList(
      user: user,
      group: group,
      messageId: message?.id,
      startFromUnreadMessages: true,
      hideEditMessageOption: false,
      hideDeleteMessageOption: false,
      style: ChatTheme.messageListStyle,
    );
  }

  Widget _buildBlockedView(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.block, size: 64, color: Colors.grey),
          SizedBox(height: 16),
          Text('You have blocked this user'),
        ],
      ),
    );
  }

  Widget _buildKickedView(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.group_off, size: 64, color: Colors.grey),
          SizedBox(height: 16),
          Text('You are not a member of this group'),
        ],
      ),
    );
  }

  Widget _buildComposer(BuildContext context) {
    if (user != null && user!.blockedByMe == true) {
      return const SizedBox.shrink();
    }
    if (group != null &&
        (group!.hasJoined == false || group!.isBannedFromGroup == true)) {
      return const SizedBox.shrink();
    }

    return CometChatCompactMessageComposer(
      user: user,
      group: group,
      compactMessageComposerStyle: ChatTheme.compactComposerStyle,
      enableRichTextFormatting: false,
    );
  }
}

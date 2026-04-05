import 'package:cometchat_chat_uikit/cometchat_chat_uikit.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:uit_buddy_mobile/features/chat/services/call_permission_service.dart';
import 'package:uit_buddy_mobile/features/chat/presentation/theme/chat_theme.dart';

class ChatConversationScreen extends StatefulWidget {
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
  State<ChatConversationScreen> createState() => _ChatConversationScreenState();
}

class _ChatConversationScreenState extends State<ChatConversationScreen> {
  final _callPermissionService = GetIt.I<CallPermissionService>();

  @override
  void initState() {
    super.initState();
    // Request call permissions when entering the conversation screen
    _callPermissionService.requestCallPermissions();
  }

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
      user: widget.user,
      group: widget.group,
      onBack: () => context.pop(),
      messageHeaderStyle: ChatTheme.messageHeaderStyle,
    );
  }

  Widget _buildMessageList(BuildContext context) {
    if (widget.user != null && widget.user!.blockedByMe == true) {
      return _buildBlockedView(context);
    }
    if (widget.group != null &&
        (widget.group!.hasJoined == false ||
            widget.group!.isBannedFromGroup == true)) {
      return _buildKickedView(context);
    }

    return CometChatMessageList(
      user: widget.user,
      group: widget.group,
      messageId: widget.message?.id,
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
    if (widget.user != null && widget.user!.blockedByMe == true) {
      return const SizedBox.shrink();
    }
    if (widget.group != null &&
        (widget.group!.hasJoined == false ||
            widget.group!.isBannedFromGroup == true)) {
      return const SizedBox.shrink();
    }

    return CometChatCompactMessageComposer(
      user: widget.user,
      group: widget.group,
      compactMessageComposerStyle: ChatTheme.compactComposerStyle,
      enableRichTextFormatting: false,
    );
  }
}

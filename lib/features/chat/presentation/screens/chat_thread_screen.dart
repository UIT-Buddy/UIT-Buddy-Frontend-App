import 'package:cometchat_chat_uikit/cometchat_chat_uikit.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ChatThreadScreen extends StatelessWidget {
  final User? user;
  final Group? group;
  final BaseMessage message;

  const ChatThreadScreen({
    super.key,
    this.user,
    this.group,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => context.pop(),
        ),
        title: const Text(
          'Thread Reply',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600),
        ),
      ),
      body: Column(
        children: [
          CometChatThreadedHeader(
            parentMessage: message,
            loggedInUser: CometChatUIKit.loggedInUser!,
          ),
          Expanded(
            child: _buildMessageList(),
          ),
          _buildComposer(),
        ],
      ),
    );
  }

  Widget _buildMessageList() {
    final requestBuilder = MessagesRequestBuilder()
      ..parentMessageId = message.id;

    return CometChatMessageList(
      user: user,
      group: group,
      messagesRequestBuilder: requestBuilder,
    );
  }

  Widget _buildComposer() {
    return CometChatCompactMessageComposer(
      user: user,
      group: group,
      parentMessageId: message.id,
    );
  }
}

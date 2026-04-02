import 'package:cometchat_chat_uikit/cometchat_chat_uikit.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:uit_buddy_mobile/app/router/route_name.dart';
import 'package:uit_buddy_mobile/features/chat/presentation/theme/chat_theme.dart';

class ChatSearchScreen extends StatelessWidget {
  const ChatSearchScreen({super.key});

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
        title: const Text('Search'),
      ),
      body: CometChatSearch(
        searchStyle: ChatTheme.searchStyle,
        searchIn: const [SearchScope.conversations, SearchScope.messages],
        onBack: () => context.pop(),
        onConversationClicked: (conversation) {
          if (conversation.conversationWith is User) {
            final user = conversation.conversationWith as User;
            context.push(
              RouteName.chatConversation,
              extra: {'user': user},
            );
          } else if (conversation.conversationWith is Group) {
            final group = conversation.conversationWith as Group;
            context.push(
              RouteName.chatConversation,
              extra: {'group': group},
            );
          }
        },
        onMessageClicked: (message) {
          final isUserMessage = message.receiverType == ReceiverTypeConstants.user;
          final sender = message.sender;
          final receiver = message.receiver as User?;

          User? user;
          Group? group;

          if (isUserMessage) {
            user = sender?.uid == CometChatUIKit.loggedInUser?.uid
                ? receiver
                : sender;
          } else {
            group = message.receiver as Group?;
          }

          context.push(
            RouteName.chatConversation,
            extra: {'user': user, 'group': group, 'message': message},
          );
        },
      ),
    );
  }
}

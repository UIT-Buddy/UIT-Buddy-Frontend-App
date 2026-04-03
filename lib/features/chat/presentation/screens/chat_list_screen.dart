import 'package:cometchat_chat_uikit/cometchat_chat_uikit.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:uit_buddy_mobile/app/router/route_name.dart';
import 'package:uit_buddy_mobile/features/chat/presentation/theme/chat_theme.dart';
import 'package:uit_buddy_mobile/features/chat/presentation/widgets/chat_empty_state.dart';

class ChatListScreen extends StatelessWidget {
  const ChatListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return CometChatConversations(
      conversationsStyle: ChatTheme.conversationsStyle,
      emptyStateView: (context) => const ChatEmptyState(
        icon: Icons.chat_bubble_outline_rounded,
        title: 'No conversations yet',
        subtitle: 'Start a new chat with your friends!',
      ),
      onSearchTap: () {
        context.push(RouteName.chatSearch);
      },
      onItemTap: (conversation) {
        if (conversation.conversationWith is User) {
          final user = conversation.conversationWith as User;
          context.push(RouteName.chatConversation, extra: {'user': user});
        } else if (conversation.conversationWith is Group) {
          final group = conversation.conversationWith as Group;
          context.push(RouteName.chatConversation, extra: {'group': group});
        }
      },
    );
  }
}

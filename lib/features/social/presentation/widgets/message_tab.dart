import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:uit_buddy_mobile/app/router/route_name.dart';
import 'package:uit_buddy_mobile/features/chat/presentation/screens/chat_list_screen.dart';

class MessageTab extends StatelessWidget {
  const MessageTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: const ChatListScreen(),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push(RouteName.chatContacts),
        child: const Icon(Icons.person_add_alt_1),
      ),
    );
  }
}

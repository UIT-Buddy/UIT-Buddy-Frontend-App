import 'package:cometchat_chat_uikit/cometchat_chat_uikit.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:uit_buddy_mobile/app/router/route_name.dart';
import 'package:uit_buddy_mobile/features/chat/presentation/theme/chat_theme.dart';

class ChatContactsScreen extends StatefulWidget {
  const ChatContactsScreen({super.key});

  @override
  State<ChatContactsScreen> createState() => _ChatContactsScreenState();
}

class _ChatContactsScreenState extends State<ChatContactsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

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
          'New Conversation',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600),
        ),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.blue,
          labelColor: Colors.blue,
          unselectedLabelColor: Colors.grey,
          tabs: const [
            Tab(text: 'Users'),
            Tab(text: 'Groups'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [_buildUsersTab(), _buildGroupsTab()],
      ),
    );
  }

  Widget _buildUsersTab() {
    return CometChatUsers(
      usersRequestBuilder: UsersRequestBuilder()..limit = 30,
      usersStyle: ChatTheme.usersStyle,
      onItemTap: (context, user) {
        context.push(RouteName.chatConversation, extra: {'user': user});
      },
    );
  }

  Widget _buildGroupsTab() {
    return CometChatGroups(
      groupsRequestBuilder: GroupsRequestBuilder()..limit = 30,
      groupsStyle: ChatTheme.groupsStyle,
      onItemTap: (context, group) {
        context.push(RouteName.chatConversation, extra: {'group': group});
      },
    );
  }
}

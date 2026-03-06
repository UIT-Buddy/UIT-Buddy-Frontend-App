import 'package:flutter/material.dart';
import 'package:uit_buddy_mobile/core/theme/app_color.dart';
import 'package:uit_buddy_mobile/core/theme/app_text_style.dart';
import 'package:uit_buddy_mobile/features/social/data/mock/mock_conversations.dart';
import 'package:uit_buddy_mobile/features/social/domain/entities/conversation_entity.dart';
import 'package:uit_buddy_mobile/features/social/presentation/screens/chat_screen.dart';
import 'package:uit_buddy_mobile/features/social/presentation/widgets/conversation_list_item.dart';

class MessageTab extends StatefulWidget {
  const MessageTab({super.key});

  @override
  State<MessageTab> createState() => _MessageTabState();
}

class _MessageTabState extends State<MessageTab> {
  final _searchController = TextEditingController();
  List<ConversationEntity> _filtered = mockConversations;

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearch);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearch() {
    final query = _searchController.text.trim().toLowerCase();
    setState(() {
      _filtered = query.isEmpty
          ? mockConversations
          : mockConversations
              .where((c) => c.name.toLowerCase().contains(query))
              .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildSearchBar(),
        const SizedBox(height: 4),
        Expanded(
          child: _filtered.isEmpty
              ? _buildEmpty()
              : ListView.builder(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  itemCount: _filtered.length,
                  itemBuilder: (context, index) {
                    final conv = _filtered[index];
                    return ConversationListItem(
                      conversation: conv,
                      onTap: () => _openChat(conv),
                    );
                  },
                ),
        ),
      ],
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
      child: Container(
        height: 40,
        decoration: BoxDecoration(
          color: AppColor.veryLightGrey,
          borderRadius: BorderRadius.circular(12),
        ),
        child: TextField(
          controller: _searchController,
          style: AppTextStyle.bodySmall,
          textAlignVertical: TextAlignVertical.center,
          decoration: InputDecoration(
            hintText: 'Tìm kiếm cuộc trò chuyện...',
            hintStyle: AppTextStyle.bodySmall.copyWith(
              color: AppColor.secondaryText,
            ),
            prefixIcon: const Icon(
              Icons.search,
              color: AppColor.secondaryText,
              size: 20,
            ),
            border: InputBorder.none,
            enabledBorder: InputBorder.none,
            focusedBorder: InputBorder.none,
            filled: false,
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
            isCollapsed: true,
          ),
        ),
      ),
    );
  }

  Widget _buildEmpty() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.search_off, color: AppColor.tertiaryText, size: 48),
          const SizedBox(height: 12),
          Text(
            'Không tìm thấy cuộc trò chuyện',
            style:
                AppTextStyle.bodyMedium.copyWith(color: AppColor.secondaryText),
          ),
        ],
      ),
    );
  }

  void _openChat(ConversationEntity conversation) {
    Navigator.of(context).push(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            ChatScreen(conversation: conversation),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          final curved = CurvedAnimation(
            parent: animation,
            curve: Curves.easeOutCubic,
            reverseCurve: Curves.easeInCubic,
          );
          return SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(1, 0),
              end: Offset.zero,
            ).animate(curved),
            child: child,
          );
        },
        transitionDuration: const Duration(milliseconds: 300),
        reverseTransitionDuration: const Duration(milliseconds: 260),
      ),
    );
  }
}

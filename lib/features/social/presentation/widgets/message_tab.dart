import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uit_buddy_mobile/app/di/app_dependencies.dart';
import 'package:uit_buddy_mobile/core/theme/app_color.dart';
import 'package:uit_buddy_mobile/core/theme/app_text_style.dart';
import 'package:uit_buddy_mobile/features/social/presentation/bloc/conversation/conversation_bloc.dart';
import 'package:uit_buddy_mobile/features/social/presentation/bloc/conversation/conversation_event.dart';
import 'package:uit_buddy_mobile/features/social/presentation/bloc/conversation/conversation_state.dart';
import 'package:uit_buddy_mobile/features/social/domain/entities/conversation_entity.dart';
import 'package:uit_buddy_mobile/features/social/presentation/screens/chat_screen.dart';
import 'package:uit_buddy_mobile/features/social/presentation/widgets/conversation_list_item.dart';
import 'package:uit_buddy_mobile/features/social/presentation/widgets/conversation_list_item_skeleton.dart';

class MessageTab extends StatelessWidget {
  const MessageTab({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          serviceLocator<ConversationBloc>()..add(const ConversationStarted()),
      child: const _MessageTabView(),
    );
  }
}

class _MessageTabView extends StatefulWidget {
  const _MessageTabView();

  @override
  State<_MessageTabView> createState() => _MessageTabViewState();
}

class _MessageTabViewState extends State<_MessageTabView> {
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildSearchBar(context),
        const SizedBox(height: 4),
        Expanded(child: _buildBody()),
      ],
    );
  }

  Widget _buildSearchBar(BuildContext context) {
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
          onChanged: (value) {
            context.read<ConversationBloc>().add(
              ConversationSearchChanged(query: value),
            );
          },
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
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 0,
              vertical: 0,
            ),
            isCollapsed: true,
          ),
        ),
      ),
    );
  }

  Widget _buildBody() {
    return BlocBuilder<ConversationBloc, ConversationState>(
      builder: (context, state) {
        if (state.status == ConversationStatus.loading) {
          return _buildLoading();
        }

        if (state.status == ConversationStatus.error) {
          return _buildError(context, state.errorMessage);
        }

        if (state.filteredConversations.isEmpty) {
          return _buildEmpty(state.status == ConversationStatus.loaded);
        }

        return RefreshIndicator(
          color: AppColor.primaryBlue,
          onRefresh: () async {
            context.read<ConversationBloc>().add(const ConversationRefreshed());
            await context.read<ConversationBloc>().stream.firstWhere(
              (s) => s.status != ConversationStatus.loading,
            );
          },
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(vertical: 4),
            itemCount: state.filteredConversations.length,
            itemBuilder: (context, index) {
              final conv = state.filteredConversations[index];
              return ConversationListItem(
                conversation: conv,
                onTap: () => _openChat(conv),
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildLoading() {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 4),
      physics: const NeverScrollableScrollPhysics(),
      itemCount: 8,
      itemBuilder: (_, _) => const ConversationListItemSkeleton(),
    );
  }

  Widget _buildError(BuildContext context, String? message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, color: AppColor.alertRed, size: 48),
          const SizedBox(height: 12),
          Text(
            message ?? 'Không thể tải cuộc trò chuyện',
            style: AppTextStyle.bodyMedium.copyWith(
              color: AppColor.secondaryText,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          TextButton(
            onPressed: () => context.read<ConversationBloc>().add(
              const ConversationRefreshed(),
            ),
            child: const Text('Thử lại'),
          ),
        ],
      ),
    );
  }

  Widget _buildEmpty(bool isLoaded) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            isLoaded ? Icons.search_off : Icons.chat_bubble_outline,
            color: AppColor.tertiaryText,
            size: 48,
          ),
          const SizedBox(height: 12),
          Text(
            isLoaded
                ? 'Không tìm thấy cuộc trò chuyện'
                : 'Chưa có cuộc trò chuyện nào',
            style: AppTextStyle.bodyMedium.copyWith(
              color: AppColor.secondaryText,
            ),
          ),
        ],
      ),
    );
  }

  void _openChat(ConversationEntity conversation) {
    Navigator.of(context).push(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            ChatScreen(userId: conversation.id),
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

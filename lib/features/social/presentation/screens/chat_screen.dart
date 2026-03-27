import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uit_buddy_mobile/app/di/app_dependencies.dart';
import 'package:uit_buddy_mobile/core/theme/app_color.dart';
import 'package:uit_buddy_mobile/core/theme/app_text_style.dart';
import 'package:uit_buddy_mobile/features/social/domain/entities/conversation_entity.dart';
import 'package:uit_buddy_mobile/features/social/domain/entities/message_entity.dart';
import 'package:uit_buddy_mobile/features/social/presentation/bloc/chat/chat_bloc.dart';
import 'package:uit_buddy_mobile/features/social/presentation/bloc/chat/chat_event.dart';
import 'package:uit_buddy_mobile/features/social/presentation/bloc/chat/chat_state.dart';
import 'package:uit_buddy_mobile/features/social/presentation/screens/chat_settings_screen.dart';

class ChatScreen extends StatelessWidget {
  final ConversationEntity conversation;

  const ChatScreen({super.key, required this.conversation});

  @override
  Widget build(BuildContext context) {
    final receiverId = conversation.conversationWith ?? conversation.id;

    return BlocProvider(
      create: (_) => serviceLocator<ChatBloc>()
        ..add(
          ChatStarted(receiverId: receiverId, isGroup: conversation.isGroup),
        ),
      child: _ChatView(conversation: conversation),
    );
  }
}

class _ChatView extends StatefulWidget {
  final ConversationEntity conversation;

  const _ChatView({required this.conversation});

  @override
  State<_ChatView> createState() => _ChatViewState();
}

class _ChatViewState extends State<_ChatView> {
  final _messageController = TextEditingController();
  final _scrollController = ScrollController();
  final _focusNode = FocusNode();
  bool _hasText = false;

  @override
  void initState() {
    super.initState();
    _messageController.addListener(() {
      final hasText = _messageController.text.trim().isNotEmpty;
      if (hasText != _hasText) setState(() => _hasText = hasText);
    });
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController
      ..removeListener(_onScroll)
      ..dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;
    // ListView with reverse: true — scroll position 0 is the bottom.
    // Near maxScrollExtent means user scrolled towards the top (older messages).
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      context.read<ChatBloc>().add(const ChatLoadMore());
    }
  }

  void _sendMessage() {
    final text = _messageController.text.trim();
    if (text.isEmpty) return;
    _messageController.clear();
    context.read<ChatBloc>().add(ChatSendText(text: text));
  }

  void _openSettings() {
    Navigator.of(context).push(
      PageRouteBuilder<void>(
        pageBuilder: (context, animation, secondaryAnimation) =>
            ChatSettingsScreen(conversation: widget.conversation),
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

  @override
  Widget build(BuildContext context) {
    return BlocListener<ChatBloc, ChatState>(
      listenWhen: (prev, curr) => prev.editingMessage != curr.editingMessage,
      listener: (context, state) {
        if (state.editingMessage != null) {
          _messageController.text = state.editingMessage!.content;
          _focusNode.requestFocus();
        } else {
          _messageController.clear();
          _focusNode.unfocus();
        }
      },
      child: Scaffold(
        backgroundColor: AppColor.pureWhite,
        appBar: _buildAppBar(),
        body: Column(
          children: [
            Expanded(child: _buildMessageList()),
            _buildInputBar(),
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: AppColor.pureWhite,
      elevation: 0,
      scrolledUnderElevation: 0.5,
      leadingWidth: 44,
      leading: IconButton(
        icon: const Icon(
          Icons.arrow_back_ios,
          size: 20,
          color: AppColor.primaryText,
        ),
        onPressed: () => Navigator.of(context).pop(),
        padding: const EdgeInsets.only(left: 12),
      ),
      title: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: _openSettings,
        child: Row(
          children: [
            Stack(
              children: [
                CircleAvatar(
                  radius: 18,
                  backgroundColor: AppColor.veryLightGrey,
                  backgroundImage: widget.conversation.avatarUrl.isNotEmpty
                      ? CachedNetworkImageProvider(
                          widget.conversation.avatarUrl,
                        )
                      : null,
                  child: widget.conversation.avatarUrl.isEmpty
                      ? Text(
                          widget.conversation.name.isNotEmpty
                              ? widget.conversation.name[0].toUpperCase()
                              : '?',
                          style: AppTextStyle.bodySmall.copyWith(
                            color: AppColor.secondaryText,
                          ),
                        )
                      : null,
                ),
                if (widget.conversation.isOnline)
                  Positioned(
                    right: 0,
                    bottom: 0,
                    child: Container(
                      width: 10,
                      height: 10,
                      decoration: BoxDecoration(
                        color: AppColor.successGreen,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: AppColor.pureWhite,
                          width: 1.5,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    widget.conversation.name,
                    style: AppTextStyle.h4.copyWith(
                      fontWeight: AppTextStyle.bold,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    widget.conversation.isOnline ? 'Online' : 'Offline',
                    style: AppTextStyle.bodySmall.copyWith(
                      color: widget.conversation.isOnline
                          ? AppColor.successGreen
                          : AppColor.secondaryText,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      actions: [
        IconButton(
          icon: const Icon(
            Icons.call_outlined,
            color: AppColor.primaryText,
            size: 22,
          ),
          onPressed: () {},
        ),
        IconButton(
          icon: const Icon(
            Icons.videocam_outlined,
            color: AppColor.primaryText,
            size: 24,
          ),
          onPressed: () {},
          padding: const EdgeInsets.only(right: 8),
        ),
      ],
      bottom: const PreferredSize(
        preferredSize: Size.fromHeight(1),
        child: Divider(height: 1, color: AppColor.dividerGrey),
      ),
    );
  }

  Widget _buildMessageList() {
    return BlocBuilder<ChatBloc, ChatState>(
      builder: (context, state) {
        if (state.status == ChatStatus.loading) {
          return const Center(
            child: CircularProgressIndicator(
              strokeWidth: 2.5,
              color: AppColor.primaryBlue,
            ),
          );
        }

        if (state.status == ChatStatus.error) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.error_outline,
                  color: AppColor.alertRed,
                  size: 48,
                ),
                const SizedBox(height: 12),
                Text(
                  state.errorMessage ?? 'Không thể tải tin nhắn',
                  style: AppTextStyle.bodyMedium.copyWith(
                    color: AppColor.secondaryText,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          );
        }

        if (state.messages.isEmpty && state.status == ChatStatus.loaded) {
          return Center(
            child: Text(
              'Chưa có tin nhắn nào. Hãy bắt đầu cuộc trò chuyện!',
              style: AppTextStyle.bodyMedium.copyWith(
                color: AppColor.secondaryText,
              ),
              textAlign: TextAlign.center,
            ),
          );
        }

        // messages are stored oldest-first; reverse:true shows newest at bottom
        // and allows scroll-up to load older messages.
        return GestureDetector(
          onTap: () => _focusNode.unfocus(),
          child: Column(
            children: [
              if (state.isLoadingMore)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 8),
                  child: Center(
                    child: SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: AppColor.primaryBlue,
                      ),
                    ),
                  ),
                ),
              Expanded(
                child: ListView.builder(
                  controller: _scrollController,
                  reverse: true,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  itemCount: state.messages.length,
                  itemBuilder: (context, index) {
                    // reverse:true means index 0 = last message (newest).
                    final reversedIndex = state.messages.length - 1 - index;
                    final msg = state.messages[reversedIndex];
                    final prevMsg = reversedIndex > 0
                        ? state.messages[reversedIndex - 1]
                        : null;
                    final autoShowTime =
                        prevMsg == null ||
                        _minutesBetween(prevMsg.sentAtRaw, msg.sentAtRaw) >= 10;
                    final nextMsg = reversedIndex < state.messages.length - 1
                        ? state.messages[reversedIndex + 1]
                        : null;
                    return _MessageBubble(
                      message: msg,
                      showTimestamp: autoShowTime,
                      nextMessage: nextMsg,
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  /// Returns gap in minutes between two messages using sentAtRaw.
  int _minutesBetween(DateTime? earlier, DateTime? later) {
    if (earlier == null || later == null) return 0;
    final diff = later.difference(earlier).inMinutes;
    return diff < 0 ? 0 : diff;
  }

  Widget _buildInputBar() {
    return BlocBuilder<ChatBloc, ChatState>(
      builder: (context, state) {
        final isEditing = state.editingMessage != null;

        return Container(
          decoration: const BoxDecoration(
            color: AppColor.pureWhite,
            border: Border(
              top: BorderSide(color: AppColor.dividerGrey, width: 1),
            ),
          ),
          child: SafeArea(
            top: false,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (isEditing)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    color: AppColor.primaryBlue.withValues(alpha: 0.05),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.edit_outlined,
                          size: 16,
                          color: AppColor.primaryBlue,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Sửa tin nhắn',
                                style: AppTextStyle.captionExtraSmall.copyWith(
                                  color: AppColor.primaryBlue,
                                  fontWeight: AppTextStyle.bold,
                                ),
                              ),
                              Text(
                                state.editingMessage!.content,
                                style: AppTextStyle.captionExtraSmall.copyWith(
                                  color: AppColor.secondaryText,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          icon: const Icon(
                            Icons.close,
                            size: 18,
                            color: AppColor.secondaryText,
                          ),
                          onPressed: () => context.read<ChatBloc>().add(
                            const ChatToggleEdit(),
                          ),
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                        ),
                      ],
                    ),
                  ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      IconButton(
                        icon: const Icon(
                          Icons.add_circle_outline,
                          color: AppColor.primaryBlue,
                          size: 26,
                        ),
                        onPressed: isEditing ? null : () {},
                        padding: const EdgeInsets.all(4),
                        constraints: const BoxConstraints(
                          minWidth: 36,
                          minHeight: 36,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Container(
                          constraints: const BoxConstraints(maxHeight: 120),
                          decoration: BoxDecoration(
                            color: AppColor.veryLightGrey,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: TextField(
                            controller: _messageController,
                            focusNode: _focusNode,
                            maxLines: null,
                            textCapitalization: TextCapitalization.sentences,
                            style: AppTextStyle.bodySmall,
                            onSubmitted: (_) =>
                                isEditing ? _updateMessage() : _sendMessage(),
                            decoration: InputDecoration(
                              hintText: 'Nhập tin nhắn...',
                              hintStyle: AppTextStyle.bodySmall.copyWith(
                                color: AppColor.secondaryText,
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 10,
                              ),
                              border: InputBorder.none,
                              enabledBorder: InputBorder.none,
                              focusedBorder: InputBorder.none,
                              filled: false,
                              suffixIcon: IconButton(
                                icon: const Icon(
                                  Icons.emoji_emotions_outlined,
                                  color: AppColor.secondaryText,
                                  size: 20,
                                ),
                                onPressed: () {},
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      AnimatedSwitcher(
                        duration: const Duration(milliseconds: 200),
                        transitionBuilder: (child, animation) =>
                            ScaleTransition(scale: animation, child: child),
                        child: _hasText || isEditing
                            ? GestureDetector(
                                key: ValueKey(isEditing ? 'update' : 'send'),
                                onTap: isEditing
                                    ? _updateMessage
                                    : _sendMessage,
                                child: Container(
                                  width: 40,
                                  height: 40,
                                  decoration: const BoxDecoration(
                                    color: AppColor.primaryBlue,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    isEditing
                                        ? Icons.check_rounded
                                        : Icons.send_rounded,
                                    color: AppColor.pureWhite,
                                    size: isEditing ? 22 : 18,
                                  ),
                                ),
                              )
                            : GestureDetector(
                                key: const ValueKey('mic'),
                                onTap: () {},
                                child: Container(
                                  width: 40,
                                  height: 40,
                                  decoration: BoxDecoration(
                                    color: AppColor.veryLightGrey,
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.mic_outlined,
                                    color: AppColor.primaryBlue,
                                    size: 22,
                                  ),
                                ),
                              ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _updateMessage() {
    final text = _messageController.text.trim();
    if (text.isEmpty) return;

    final state = context.read<ChatBloc>().state;
    final editingMsg = state.editingMessage;
    if (editingMsg == null) return;

    context.read<ChatBloc>().add(
      ChatEditMessage(
        messageId: editingMsg.id,
        text: text,
        receiverId: editingMsg.receiverId,
        isGroup: editingMsg.isGroup,
      ),
    );
    _messageController.clear();
    _focusNode.unfocus();
  }
}

class _MessageBubble extends StatefulWidget {
  final MessageEntity message;
  final bool showTimestamp;
  final MessageEntity? nextMessage;

  const _MessageBubble({
    required this.message,
    required this.showTimestamp,
    this.nextMessage,
  });

  @override
  State<_MessageBubble> createState() => _MessageBubbleState();
}

class _MessageBubbleState extends State<_MessageBubble> {
  bool _tappedTimestamp = false;

  void _onBubbleTap() {
    FocusScope.of(context).unfocus();
    if (!widget.showTimestamp) {
      setState(() => _tappedTimestamp = !_tappedTimestamp);
    }
  }

  void _onBubbleLongPress() {
    if (!widget.message.isMine) return;

    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (bottomSheetContext) => Container(
        decoration: const BoxDecoration(
          color: AppColor.pureWhite,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 8),
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColor.dividerGrey,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 16),
            ListTile(
              leading: const Icon(
                Icons.edit_outlined,
                color: AppColor.primaryBlue,
              ),
              title: Text('Sửa tin nhắn', style: AppTextStyle.bodyMedium),
              onTap: () {
                Navigator.pop(bottomSheetContext);
                context.read<ChatBloc>().add(
                  ChatToggleEdit(message: widget.message),
                );
              },
            ),
            ListTile(
              leading: const Icon(
                Icons.delete_outline,
                color: AppColor.alertRed,
              ),
              title: Text(
                'Xóa tin nhắn',
                style: AppTextStyle.bodyMedium.copyWith(
                  color: AppColor.alertRed,
                ),
              ),
              onTap: () {
                Navigator.pop(bottomSheetContext);
                _confirmDelete();
              },
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  void _confirmDelete() {
    showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Xóa tin nhắn?'),
        content: const Text('Bạn có chắc chắn muốn xóa tin nhắn này không?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Hủy'),
          ),
          TextButton(
            onPressed: () {
              context.read<ChatBloc>().add(
                ChatDeleteMessage(messageId: widget.message.id),
              );
              Navigator.pop(dialogContext);
            },
            child: const Text(
              'Xóa',
              style: TextStyle(color: AppColor.alertRed),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isMine = widget.message.isMine;
    final isLastInGroup =
        widget.nextMessage == null ||
        widget.nextMessage!.isMine != widget.message.isMine;
    final showTs = widget.showTimestamp || _tappedTimestamp;

    return Padding(
      padding: EdgeInsets.only(
        top: showTs ? 0 : 2,
        bottom: isLastInGroup ? 8 : 2,
      ),
      child: Column(
        children: [
          if (showTs) _buildTimestamp(),
          GestureDetector(
            onTap: _onBubbleTap,
            onLongPress: _onBubbleLongPress,
            behavior: HitTestBehavior.opaque,
            child: Row(
              mainAxisAlignment: isMine
                  ? MainAxisAlignment.end
                  : MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                if (!isMine) const SizedBox(width: 4),
                Flexible(
                  child: Container(
                    margin: EdgeInsets.only(
                      left: isMine ? 60 : 0,
                      right: isMine ? 0 : 60,
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: isMine
                          ? AppColor.primaryBlue
                          : AppColor.veryLightGrey,
                      borderRadius: BorderRadius.only(
                        topLeft: const Radius.circular(18),
                        topRight: const Radius.circular(18),
                        bottomLeft: Radius.circular(isMine ? 18 : 4),
                        bottomRight: Radius.circular(isMine ? 4 : 18),
                      ),
                    ),
                    child: Text(
                      widget.message.content,
                      style: AppTextStyle.bodySmall.copyWith(
                        color: isMine
                            ? AppColor.pureWhite
                            : AppColor.primaryText,
                        height: 1.4,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          if (isLastInGroup)
            Padding(
              padding: EdgeInsets.only(
                left: isMine ? 0 : 4,
                right: isMine ? 4 : 0,
                top: 3,
              ),
              child: Align(
                alignment: isMine
                    ? Alignment.centerRight
                    : Alignment.centerLeft,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (widget.message.isEdited) ...[
                      Text(
                        'Đã chỉnh sửa',
                        style: AppTextStyle.captionExtraSmall.copyWith(
                          fontStyle: FontStyle.italic,
                          color: AppColor.secondaryText.withValues(alpha: 0.7),
                        ),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '•',
                        style: AppTextStyle.captionExtraSmall.copyWith(
                          color: AppColor.secondaryText.withValues(alpha: 0.5),
                        ),
                      ),
                      const SizedBox(width: 4),
                    ],
                    Text(
                      widget.message.time,
                      style: AppTextStyle.captionExtraSmall,
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildTimestamp() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Center(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          decoration: BoxDecoration(
            color: AppColor.veryLightGrey,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            widget.message.time,
            style: AppTextStyle.captionExtraSmall.copyWith(
              color: AppColor.secondaryText,
            ),
          ),
        ),
      ),
    );
  }
}

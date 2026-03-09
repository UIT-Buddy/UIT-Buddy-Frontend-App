import 'package:flutter/material.dart';
import 'package:uit_buddy_mobile/core/theme/app_color.dart';
import 'package:uit_buddy_mobile/core/theme/app_text_style.dart';
import 'package:uit_buddy_mobile/features/social/data/mock/mock_messages.dart';
import 'package:uit_buddy_mobile/features/social/domain/entities/conversation_entity.dart';
import 'package:uit_buddy_mobile/features/social/domain/entities/message_entity.dart';
import 'package:uit_buddy_mobile/features/social/presentation/screens/chat_settings_screen.dart';

class ChatScreen extends StatefulWidget {
  final ConversationEntity conversation;

  const ChatScreen({super.key, required this.conversation});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _messageController = TextEditingController();
  final _scrollController = ScrollController();
  final _focusNode = FocusNode();
  late List<MessageEntity> _messages;
  bool _hasText = false;

  @override
  void initState() {
    super.initState();
    _messages = getMockMessages(widget.conversation.id);
    _messageController.addListener(() {
      final hasText = _messageController.text.trim().isNotEmpty;
      if (hasText != _hasText) setState(() => _hasText = hasText);
    });
    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    _focusNode.dispose();
    super.dispose();
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

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  void _onSend() {
    final text = _messageController.text.trim();
    if (text.isEmpty) return;
    setState(() {
      _messages = [
        ..._messages,
        MessageEntity(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          senderId: 'me',
          senderName: 'Minh',
          content: text,
          time: _currentTime(),
          isMine: true,
        ),
      ];
      _messageController.clear();
    });
    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());
  }

  String _currentTime() {
    final now = DateTime.now();
    return '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.pureWhite,
      appBar: _buildAppBar(),
      body: Column(
        children: [
          Expanded(child: _buildMessageList()),
          _buildInputBar(),
        ],
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
                  backgroundImage: NetworkImage(widget.conversation.avatarUrl),
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
                    style: AppTextStyle.bodySmall.copyWith(
                      fontWeight: AppTextStyle.bold,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    widget.conversation.isOnline ? 'Đang hoạt động' : 'Offline',
                    style: AppTextStyle.captionSmall.copyWith(
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

  /// Returns the gap in minutes between two "HH:mm" time strings.
  int _minutesBetween(String earlier, String later) {
    final e = earlier.split(':');
    final l = later.split(':');
    final eMin = int.parse(e[0]) * 60 + int.parse(e[1]);
    final lMin = int.parse(l[0]) * 60 + int.parse(l[1]);
    final diff = lMin - eMin;
    return diff < 0 ? diff + 1440 : diff;
  }

  Widget _buildMessageList() {
    return GestureDetector(
      onTap: () => _focusNode.unfocus(),
      child: ListView.builder(
        controller: _scrollController,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        itemCount: _messages.length,
        itemBuilder: (context, index) {
          final msg = _messages[index];
          final prevMsg = index > 0 ? _messages[index - 1] : null;
          final autoShowTime =
              prevMsg == null || _minutesBetween(prevMsg.time, msg.time) >= 10;
          return _MessageBubble(
            message: msg,
            showTimestamp: autoShowTime,
            nextMessage: index < _messages.length - 1
                ? _messages[index + 1]
                : null,
          );
        },
      ),
    );
  }

  Widget _buildInputBar() {
    return Container(
      decoration: const BoxDecoration(
        color: AppColor.pureWhite,
        border: Border(top: BorderSide(color: AppColor.dividerGrey, width: 1)),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              // Extra action
              IconButton(
                icon: const Icon(
                  Icons.add_circle_outline,
                  color: AppColor.primaryBlue,
                  size: 26,
                ),
                onPressed: () {},
                padding: const EdgeInsets.all(4),
                constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
              ),
              const SizedBox(width: 4),
              // Text field
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
              // Send / mic button
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 200),
                transitionBuilder: (child, animation) =>
                    ScaleTransition(scale: animation, child: child),
                child: _hasText
                    ? GestureDetector(
                        key: const ValueKey('send'),
                        onTap: _onSend,
                        child: Container(
                          width: 40,
                          height: 40,
                          decoration: const BoxDecoration(
                            color: AppColor.primaryBlue,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.send_rounded,
                            color: AppColor.pureWhite,
                            size: 18,
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
      ),
    );
  }
}

/// Individual message bubble widget
class _MessageBubble extends StatefulWidget {
  final MessageEntity message;

  /// True when the gap from the previous message is ≥ 10 min (always visible).
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
    // Only toggle tap-timestamp when the auto-timestamp is not already shown.
    if (!widget.showTimestamp) {
      setState(() => _tappedTimestamp = !_tappedTimestamp);
    }
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
            behavior: HitTestBehavior.opaque,
            child: Row(
              mainAxisAlignment: isMine
                  ? MainAxisAlignment.end
                  : MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                if (!isMine && isLastInGroup) ...[
                  const SizedBox(width: 4),
                ] else if (!isMine) ...[
                  const SizedBox(width: 4),
                ],
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
                child: Text(
                  widget.message.time,
                  style: AppTextStyle.captionExtraSmall,
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

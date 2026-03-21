import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:uit_buddy_mobile/core/theme/app_color.dart';
import 'package:uit_buddy_mobile/core/theme/app_text_style.dart';
import 'package:uit_buddy_mobile/features/social/presentation/constants/post_detail_text.dart';

class CommentInputBar extends StatefulWidget {
  final String? replyingToCommentId;
  final String? replyingToAuthorName;
  final String? avatarUrl;
  final String? avatarLetter;
  final bool isSubmitting;
  final VoidCallback? onCancelReply;
  final void Function(String content) onSubmit;
  final FocusNode? focusNode;

  const CommentInputBar({
    super.key,
    this.replyingToCommentId,
    this.replyingToAuthorName,
    this.avatarUrl,
    this.avatarLetter,
    this.isSubmitting = false,
    this.onCancelReply,
    required this.onSubmit,
    this.focusNode,
  });

  @override
  State<CommentInputBar> createState() => _CommentInputBarState();
}

class _CommentInputBarState extends State<CommentInputBar> {
  late final TextEditingController _controller;
  late final FocusNode _focusNode;
  bool _hasText = false;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    _focusNode = widget.focusNode ?? FocusNode();
    _controller.addListener(() {
      final hasText = _controller.text.trim().isNotEmpty;
      if (hasText != _hasText) {
        setState(() => _hasText = hasText);
      }
    });
  }

  @override
  void didUpdateWidget(covariant CommentInputBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Clear field after successful submission
    if (!widget.isSubmitting && oldWidget.isSubmitting) {
      _controller.clear();
    }
    // Auto-focus when reply mode activates
    if (widget.replyingToCommentId != null &&
        oldWidget.replyingToCommentId == null) {
      _focusNode.requestFocus();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    // Only dispose if we created the FocusNode ourselves
    if (widget.focusNode == null) _focusNode.dispose();
    super.dispose();
  }

  void _submit() {
    final text = _controller.text.trim();
    if (text.isEmpty || widget.isSubmitting) return;
    widget.onSubmit(text);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(color: AppColor.dividerGrey, width: 0.5),
        ),
        boxShadow: [
          BoxShadow(
            color: AppColor.shadowColor,
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (widget.replyingToCommentId != null)
            _ReplyBanner(
              authorName: widget.replyingToAuthorName ?? '',
              onCancel: widget.onCancelReply,
            ),
          SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  _Avatar(
                    url: widget.avatarUrl,
                    letter: widget.avatarLetter ?? 'U',
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: AppColor.veryLightGrey,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: TextField(
                        controller: _controller,
                        focusNode: _focusNode,
                        maxLines: 4,
                        minLines: 1,
                        textCapitalization: TextCapitalization.sentences,
                        style: AppTextStyle.bodySmall,
                        decoration: InputDecoration(
                          hintText: widget.replyingToCommentId != null
                              ? PostDetailText.replyToComment
                              : PostDetailText.writeComment,
                          hintStyle: AppTextStyle.bodySmall.copyWith(
                            color: AppColor.tertiaryText,
                          ),
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 10,
                          ),
                        ),
                        onSubmitted: (_) => _submit(),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  _SendButton(
                    active: _hasText && !widget.isSubmitting,
                    isLoading: widget.isSubmitting,
                    onTap: _submit,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Reply banner ─────────────────────────────────────────────────────────────

class _ReplyBanner extends StatelessWidget {
  final String authorName;
  final VoidCallback? onCancel;

  const _ReplyBanner({required this.authorName, this.onCancel});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColor.primaryBlue10,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: Row(
        children: [
          const Icon(Icons.reply, size: 14, color: AppColor.primaryBlue),
          const SizedBox(width: 6),
          Expanded(
            child: Text(
              PostDetailText.replyingTo(authorName),
              style: AppTextStyle.captionMedium.copyWith(
                color: AppColor.primaryBlue,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          GestureDetector(
            onTap: onCancel,
            child: const Icon(
              Icons.close,
              size: 16,
              color: AppColor.primaryBlue,
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Avatar ───────────────────────────────────────────────────────────────────

class _Avatar extends StatelessWidget {
  final String? url;
  final String letter;

  const _Avatar({this.url, required this.letter});

  @override
  Widget build(BuildContext context) {
    if (url != null && url!.isNotEmpty) {
      return CircleAvatar(
        radius: 16,
        backgroundColor: AppColor.veryLightGrey,
        backgroundImage: CachedNetworkImageProvider(url!),
      );
    }
    return CircleAvatar(
      radius: 16,
      backgroundColor: AppColor.primaryBlue20,
      child: Text(
        letter.isNotEmpty ? letter[0].toUpperCase() : 'U',
        style: AppTextStyle.captionSmall.copyWith(
          color: AppColor.primaryBlue,
          fontWeight: AppTextStyle.bold,
        ),
      ),
    );
  }
}

// ─── Send button ──────────────────────────────────────────────────────────────

class _SendButton extends StatelessWidget {
  final bool active;
  final bool isLoading;
  final VoidCallback onTap;

  const _SendButton({
    required this.active,
    required this.isLoading,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: active ? onTap : null,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: active ? AppColor.primaryBlue : AppColor.dividerGrey,
          shape: BoxShape.circle,
        ),
        alignment: Alignment.center,
        child: isLoading
            ? const SizedBox(
                width: 16,
                height: 16,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Colors.white,
                ),
              )
            : const Icon(Icons.send_rounded, color: Colors.white, size: 16),
      ),
    );
  }
}

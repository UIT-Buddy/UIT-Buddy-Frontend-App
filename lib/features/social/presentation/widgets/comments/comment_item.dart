import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fpdart/fpdart.dart';
import 'package:uit_buddy_mobile/core/theme/app_color.dart';
import 'package:uit_buddy_mobile/core/theme/app_text_style.dart';
import 'package:uit_buddy_mobile/core/utils/datetime.dart';
import 'package:uit_buddy_mobile/features/social/domain/entities/comment_entity.dart';
import 'package:uit_buddy_mobile/features/social/presentation/constants/post_detail_text.dart';

// Slightly darker grey for reply bubbles to show hierarchy against parent grey
const _kReplyBubbleColor = Color(0xFFEBEBF0);
const _kThreadLineColor = Color(0xFFDDE1E7);

class CommentItemWidget extends StatelessWidget {
  final CommentEntity comment;
  final String? currentUserMssv;
  final List<CommentEntity>? loadedReplies;
  final bool isLoadingReplies;
  final VoidCallback onLikeTap;
  final VoidCallback? onReplyTap;
  final VoidCallback? onDeleteTap;
  final VoidCallback? onViewRepliesTap;
  final void Function(String replyId)? onReplyLikeTap;
  final void Function(String replyId)? onReplyDeleteTap;

  const CommentItemWidget({
    super.key,
    required this.comment,
    this.currentUserMssv,
    this.loadedReplies,
    this.isLoadingReplies = false,
    required this.onLikeTap,
    this.onReplyTap,
    this.onDeleteTap,
    this.onViewRepliesTap,
    this.onReplyLikeTap,
    this.onReplyDeleteTap,
  });

  bool get _isAuthor =>
      currentUserMssv != null && currentUserMssv == comment.author?.mssv;

  bool get _showThreadLine =>
      (loadedReplies != null && loadedReplies!.isNotEmpty) ||
      isLoadingReplies ||
      (comment.replyCount > 0 && loadedReplies == null && !isLoadingReplies);

  @override
  Widget build(BuildContext context) {
    final hasReplies = loadedReplies != null && loadedReplies!.isNotEmpty;
    final showViewReplies =
        comment.replyCount > 0 && loadedReplies == null && !isLoadingReplies;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Avatar + vertical thread line ──────────────────────────────
            _AvatarThreadColumn(
              author: comment.author,
              radius: 16,
              showLine: _showThreadLine,
            ),
            const SizedBox(width: 8),
            // ── Bubble + actions + replies ─────────────────────────────────
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _CommentBubble(
                    authorName:
                        comment.author?.fullName ?? PostDetailText.anonymous,
                    content: comment.content,
                    color: AppColor.veryLightGrey,
                    withShadow: false,
                  ),
                  _ActionsRow(
                    createdAt: comment.createdAt,
                    isLiked: comment.isLiked,
                    likeCount: comment.likeCount,
                    onLikeTap: onLikeTap,
                    onReplyTap: onReplyTap,
                    menuButton: _CommentMenuButton(
                      isAuthor: _isAuthor,
                      content: comment.content,
                      onDelete: onDeleteTap,
                    ),
                  ),
                  if (showViewReplies) _buildViewRepliesButton(),
                  if (isLoadingReplies) _buildRepliesLoader(),
                  if (hasReplies) _buildRepliesList(context),
                  const SizedBox(height: 4),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildViewRepliesButton() {
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: GestureDetector(
        onTap: onViewRepliesTap,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 18,
              height: 1.5,
              margin: const EdgeInsets.only(right: 6),
              decoration: BoxDecoration(
                color: AppColor.primaryBlue,
                borderRadius: BorderRadius.circular(1),
              ),
            ),
            Text(
              PostDetailText.viewReplies(comment.replyCount),
              style: AppTextStyle.captionMedium.copyWith(
                fontWeight: AppTextStyle.bold,
                color: AppColor.primaryBlue,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRepliesLoader() {
    return const Padding(
      padding: EdgeInsets.only(top: 10),
      child: SizedBox(
        height: 20,
        width: 20,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          color: AppColor.primaryBlue,
        ),
      ),
    );
  }

  Widget _buildRepliesList(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Column(
        children: loadedReplies!.sortWithDate((e) => e.createdAt).asMap().entries.map((entry) {
          final isLast = entry.key == loadedReplies!.length - 1;
          final reply = entry.value;
          final isReplyAuthor =
              currentUserMssv != null && currentUserMssv == reply.author?.mssv;
          return Padding(
            padding: EdgeInsets.only(bottom: isLast ? 0 : 8),
            child: _ReplyItemWidget(
              reply: reply,
              isAuthor: isReplyAuthor,
              isLast: isLast,
              onLikeTap: () => onReplyLikeTap?.call(reply.id),
              onDeleteTap: () => onReplyDeleteTap?.call(reply.id),
            ),
          );
        }).toList(),
      ),
    );
  }
}

// ─── Shared: avatar column with optional thread line ─────────────────────────

class _AvatarThreadColumn extends StatelessWidget {
  final CommentAuthorEntity? author;
  final double radius;
  final bool showLine;

  const _AvatarThreadColumn({
    required this.author,
    required this.radius,
    required this.showLine,
  });

  @override
  Widget build(BuildContext context) {
    final url = author?.avatarUrl;
    final letter = author?.avatarLetter ?? '?';
    final size = radius * 2;

    Widget avatar;
    if (url != null && url.isNotEmpty) {
      avatar = CircleAvatar(
        radius: radius,
        backgroundColor: AppColor.veryLightGrey,
        backgroundImage: CachedNetworkImageProvider(url),
      );
    } else {
      avatar = CircleAvatar(
        radius: radius,
        backgroundColor: AppColor.primaryBlue20,
        child: Text(
          letter,
          style: (radius >= 16
                  ? AppTextStyle.captionSmall
                  : AppTextStyle.captionExtraSmall)
              .copyWith(
            color: AppColor.primaryBlue,
            fontWeight: AppTextStyle.bold,
          ),
        ),
      );
    }

    return SizedBox(
      width: size,
      child: Column(
        children: [
          avatar,
          if (showLine)
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(top: 5),
                child: Center(
                  child: Container(
                    width: 2,
                    decoration: BoxDecoration(
                      color: _kThreadLineColor,
                      borderRadius: BorderRadius.circular(1),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

// ─── Shared: comment / reply bubble ──────────────────────────────────────────

class _CommentBubble extends StatelessWidget {
  final String authorName;
  final String content;
  final Color color;
  final bool withShadow;

  const _CommentBubble({
    required this.authorName,
    required this.content,
    required this.color,
    this.withShadow = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(14),
        boxShadow: withShadow
            ? [
                BoxShadow(
                  color: AppColor.shadowColor,
                  blurRadius: 4,
                  offset: const Offset(0, 1),
                ),
              ]
            : null,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            authorName,
            style: AppTextStyle.bodySmall.copyWith(
              fontWeight: AppTextStyle.bold,
            ),
          ),
          const SizedBox(height: 3),
          Text(content, style: AppTextStyle.bodySmall),
        ],
      ),
    );
  }
}

// ─── Shared: actions row (time · like · reply) ────────────────────────────────

class _ActionsRow extends StatelessWidget {
  final DateTime createdAt;
  final bool isLiked;
  final int likeCount;
  final VoidCallback onLikeTap;
  final VoidCallback? onReplyTap;
  final Widget menuButton;

  const _ActionsRow({
    required this.createdAt,
    required this.isLiked,
    required this.likeCount,
    required this.onLikeTap,
    this.onReplyTap,
    required this.menuButton,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, top: 0),
      child: Row(
        children: [
          Text(
            DateTimeUtils.getTimeAgo(createdAt),
            style: AppTextStyle.captionMedium,
          ),
          const SizedBox(width: 14),
          _LikeButton(
            isLiked: isLiked,
            likeCount: likeCount,
            onTap: onLikeTap,
          ),
          if (onReplyTap != null) ...[
            const SizedBox(width: 14),
            GestureDetector(
              onTap: onReplyTap,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.reply_rounded,
                    size: 14,
                    color: AppColor.secondaryText,
                  ),
                  const SizedBox(width: 3),
                  Text(
                    PostDetailText.reply,
                    style: AppTextStyle.captionMedium,
                  ),
                ],
              ),
            ),
          ],
          const Spacer(),
          menuButton,
        ],
      ),
    );
  }
}

// ─── Reply item ───────────────────────────────────────────────────────────────

class _ReplyItemWidget extends StatelessWidget {
  final CommentEntity reply;
  final bool isAuthor;
  final bool isLast;
  final VoidCallback onLikeTap;
  final VoidCallback? onDeleteTap;

  const _ReplyItemWidget({
    required this.reply,
    required this.isAuthor,
    required this.isLast,
    required this.onLikeTap,
    this.onDeleteTap,
  });

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Avatar column — no thread line on last reply
          _AvatarThreadColumn(
            author: reply.author,
            radius: 14,
            showLine: false,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _CommentBubble(
                  authorName:
                      reply.author?.fullName ?? PostDetailText.anonymous,
                  content: reply.content,
                  color: _kReplyBubbleColor,
                  withShadow: false,
                ),
                _ActionsRow(
                  createdAt: reply.createdAt,
                  isLiked: reply.isLiked,
                  likeCount: reply.likeCount,
                  onLikeTap: onLikeTap,
                  menuButton: _CommentMenuButton(
                    isAuthor: isAuthor,
                    content: reply.content,
                    onDelete: onDeleteTap,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Like button ──────────────────────────────────────────────────────────────

class _LikeButton extends StatelessWidget {
  final bool isLiked;
  final int likeCount;
  final VoidCallback onTap;

  const _LikeButton({
    required this.isLiked,
    required this.likeCount,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isLiked ? Icons.favorite_rounded : Icons.favorite_border_rounded,
            size: 14,
            color: isLiked ? AppColor.alertRed : AppColor.secondaryText,
          ),
          const SizedBox(width: 4),
          if (likeCount > 0)
            Text(
              '$likeCount',
              style: AppTextStyle.captionMedium.copyWith(
                color: isLiked ? AppColor.alertRed : AppColor.secondaryText,
                fontWeight:
                    isLiked ? AppTextStyle.bold : AppTextStyle.regular,
              ),
            )
          else
            Text(
              PostDetailText.like,
              style: AppTextStyle.captionMedium.copyWith(
                color: AppColor.secondaryText,
              ),
            ),
        ],
      ),
    );
  }
}

// ─── Menu button ──────────────────────────────────────────────────────────────

enum _CommentMenuAction { copy, delete, report }

class _CommentMenuButton extends StatelessWidget {
  final bool isAuthor;
  final String content;
  final VoidCallback? onDelete;

  const _CommentMenuButton({
    required this.isAuthor,
    required this.content,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<_CommentMenuAction>(
      icon: const Icon(
        Icons.more_horiz,
        color: AppColor.secondaryText,
        size: 16,
      ),
      padding: EdgeInsets.zero,
      iconSize: 16,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: Colors.white,
      elevation: 4,
      offset: const Offset(0, 8),
      onSelected: (action) => _handleAction(context, action),
      itemBuilder: (_) => [
        _item(
          value: _CommentMenuAction.copy,
          icon: Icons.content_copy_rounded,
          label: PostDetailText.copy,
          color: AppColor.primaryText,
        ),
        if (isAuthor)
          _item(
            value: _CommentMenuAction.delete,
            icon: Icons.delete_outline_rounded,
            label: PostDetailText.deleteComment,
            color: AppColor.alertRed,
          )
        else
          _item(
            value: _CommentMenuAction.report,
            icon: Icons.flag_outlined,
            label: PostDetailText.report,
            color: AppColor.alertRed,
          ),
      ],
    );
  }

  PopupMenuItem<_CommentMenuAction> _item({
    required _CommentMenuAction value,
    required IconData icon,
    required String label,
    required Color color,
  }) {
    return PopupMenuItem<_CommentMenuAction>(
      value: value,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Row(
        children: [
          Icon(icon, size: 16, color: color),
          const SizedBox(width: 10),
          Text(
            label,
            style: AppTextStyle.captionLarge.copyWith(color: color),
          ),
        ],
      ),
    );
  }

  Future<void> _handleAction(
    BuildContext context,
    _CommentMenuAction action,
  ) async {
    switch (action) {
      case _CommentMenuAction.copy:
        await Clipboard.setData(ClipboardData(text: content));
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(PostDetailText.copiedToClipboard),
              duration: Duration(seconds: 2),
            ),
          );
        }
      case _CommentMenuAction.report:
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(PostDetailText.reportSent),
              duration: Duration(seconds: 2),
            ),
          );
        }
      case _CommentMenuAction.delete:
        await _confirmDelete(context);
    }
  }

  Future<void> _confirmDelete(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text(PostDetailText.deleteCommentTitle),
        content: const Text(PostDetailText.deleteCommentBody),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text(PostDetailText.cancel),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColor.alertRed,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              elevation: 0,
            ),
            child: const Text(PostDetailText.delete),
          ),
        ],
      ),
    );
    if (confirmed == true) onDelete?.call();
  }
}

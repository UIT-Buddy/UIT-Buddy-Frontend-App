import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:uit_buddy_mobile/core/theme/app_color.dart';
import 'package:uit_buddy_mobile/core/theme/app_text_style.dart';
import 'package:uit_buddy_mobile/features/social/domain/entities/comment_entity.dart';
import 'package:uit_buddy_mobile/features/social/presentation/constants/post_detail_text.dart';

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
      currentUserMssv != null &&
      currentUserMssv == comment.author?.mssv;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildCommentRow(context),
          if (comment.replyCount > 0 &&
              loadedReplies == null &&
              !isLoadingReplies)
            _buildViewRepliesButton(),
          if (isLoadingReplies) _buildRepliesLoader(),
          if (loadedReplies != null && loadedReplies!.isNotEmpty)
            _buildRepliesList(context),
        ],
      ),
    );
  }

  Widget _buildCommentRow(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildAvatar(comment.author),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Bubble
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: AppColor.veryLightGrey,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      comment.author?.fullName ?? PostDetailText.anonymous,
                      style: AppTextStyle.bodySmall.copyWith(
                        fontWeight: AppTextStyle.bold,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      comment.content,
                      style: AppTextStyle.bodySmall,
                    ),
                  ],
                ),
              ),
              // Actions row
              Padding(
                padding: const EdgeInsets.only(left: 4, top: 4),
                child: Row(
                  children: [
                    Text(
                      comment.timeAgo,
                      style: AppTextStyle.captionMedium,
                    ),
                    const SizedBox(width: 14),
                    _LikeButton(
                      isLiked: comment.isLiked,
                      likeCount: comment.likeCount,
                      onTap: onLikeTap,
                    ),
                    if (onReplyTap != null) ...[
                      const SizedBox(width: 14),
                      GestureDetector(
                        onTap: onReplyTap,
                        child: Text(
                          PostDetailText.reply,
                          style: AppTextStyle.captionMedium,
                        ),
                      ),
                    ],
                    const Spacer(),
                    _CommentMenuButton(
                      isAuthor: _isAuthor,
                      content: comment.content,
                      onDelete: onDeleteTap,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildViewRepliesButton() {
    return Padding(
      padding: const EdgeInsets.only(left: 44, top: 4),
      child: GestureDetector(
        onTap: onViewRepliesTap,
        child: Row(
          children: [
            Container(
              width: 20,
              height: 1,
              color: AppColor.secondaryText,
              margin: const EdgeInsets.only(right: 8),
            ),
            Text(
              PostDetailText.viewReplies(comment.replyCount),
              style: AppTextStyle.captionMedium.copyWith(
                fontWeight: AppTextStyle.bold,
                color: AppColor.secondaryText,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRepliesLoader() {
    return const Padding(
      padding: EdgeInsets.only(left: 44, top: 8),
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
      padding: const EdgeInsets.only(left: 36, top: 6),
      child: Column(
        children: loadedReplies!.map((reply) {
          final isReplyAuthor =
              currentUserMssv != null &&
              currentUserMssv == reply.author?.mssv;
          return Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: _ReplyItemWidget(
              reply: reply,
              isAuthor: isReplyAuthor,
              onLikeTap: () => onReplyLikeTap?.call(reply.id),
              onDeleteTap: () => onReplyDeleteTap?.call(reply.id),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildAvatar(CommentAuthorEntity? author) {
    final url = author?.avatarUrl;
    final letter = author?.avatarLetter ?? '?';

    if (url != null && url.isNotEmpty) {
      return CircleAvatar(
        radius: 16,
        backgroundColor: AppColor.veryLightGrey,
        backgroundImage: NetworkImage(url),
      );
    }
    return CircleAvatar(
      radius: 16,
      backgroundColor: AppColor.primaryBlue20,
      child: Text(
        letter,
        style: AppTextStyle.captionSmall.copyWith(
          color: AppColor.primaryBlue,
          fontWeight: AppTextStyle.bold,
        ),
      ),
    );
  }
}

// ─── Reply item ──────────────────────────────────────────────────────────────

class _ReplyItemWidget extends StatelessWidget {
  final CommentEntity reply;
  final bool isAuthor;
  final VoidCallback onLikeTap;
  final VoidCallback? onDeleteTap;

  const _ReplyItemWidget({
    required this.reply,
    required this.isAuthor,
    required this.onLikeTap,
    this.onDeleteTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildAvatar(),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: AppColor.veryLightGrey,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      reply.author?.fullName ?? PostDetailText.anonymous,
                      style: AppTextStyle.captionLarge.copyWith(
                        fontWeight: AppTextStyle.bold,
                        color: AppColor.primaryText,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      reply.content,
                      style: AppTextStyle.captionLarge.copyWith(
                        color: AppColor.primaryText,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 4, top: 4),
                child: Row(
                  children: [
                    Text(reply.timeAgo, style: AppTextStyle.captionMedium),
                    const SizedBox(width: 14),
                    _LikeButton(
                      isLiked: reply.isLiked,
                      likeCount: reply.likeCount,
                      onTap: onLikeTap,
                    ),
                    const Spacer(),
                    _CommentMenuButton(
                      isAuthor: isAuthor,
                      content: reply.content,
                      onDelete: onDeleteTap,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAvatar() {
    final url = reply.author?.avatarUrl;
    final letter = reply.author?.avatarLetter ?? '?';

    if (url != null && url.isNotEmpty) {
      return CircleAvatar(
        radius: 14,
        backgroundColor: AppColor.veryLightGrey,
        backgroundImage: NetworkImage(url),
      );
    }
    return CircleAvatar(
      radius: 14,
      backgroundColor: AppColor.primaryBlue20,
      child: Text(
        letter,
        style: AppTextStyle.captionExtraSmall.copyWith(
          color: AppColor.primaryBlue,
          fontWeight: AppTextStyle.bold,
        ),
      ),
    );
  }
}

// ─── Like button ─────────────────────────────────────────────────────────────

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
          Text(
            PostDetailText.like,
            style: AppTextStyle.captionMedium.copyWith(
              color: isLiked ? AppColor.alertRed : AppColor.secondaryText,
              fontWeight:
                  isLiked ? AppTextStyle.bold : AppTextStyle.regular,
            ),
          ),
          if (likeCount > 0) ...[
            const SizedBox(width: 4),
            Text('$likeCount', style: AppTextStyle.captionMedium),
          ],
        ],
      ),
    );
  }
}

// ─── Menu button ─────────────────────────────────────────────────────────────

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

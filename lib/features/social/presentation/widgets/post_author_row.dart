import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:uit_buddy_mobile/core/theme/app_color.dart';
import 'package:uit_buddy_mobile/core/theme/app_text_style.dart';
import 'package:uit_buddy_mobile/features/social/presentation/constants/social_text.dart';

enum _PostMenuAction { copyText, savePost, report, hide, edit, delete }

class PostAuthorRow extends StatelessWidget {
  final String authorName;
  final String authorClass;
  final String? authorAvatarUrl;
  final String timeAgo;
  final bool isAuthor;
  final String postContent;
  final VoidCallback? onDeleteConfirmed;
  final VoidCallback? onEditTap;

  const PostAuthorRow({
    super.key,
    required this.authorName,
    required this.authorClass,
    this.authorAvatarUrl,
    required this.timeAgo,
    this.isAuthor = false,
    this.postContent = '',
    this.onDeleteConfirmed,
    this.onEditTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        children: [
          _buildAvatar(),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  authorName,
                  style: AppTextStyle.bodySmall.copyWith(
                    fontWeight: AppTextStyle.bold,
                  ),
                ),
                const SizedBox(height: 2),
                Row(
                  children: [
                    Text(authorClass, style: AppTextStyle.captionMedium),
                    const SizedBox(width: 6),
                    Container(
                      width: 3,
                      height: 3,
                      decoration: const BoxDecoration(
                        color: AppColor.secondaryText,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(timeAgo, style: AppTextStyle.captionMedium),
                  ],
                ),
              ],
            ),
          ),
          _buildMoreButton(context),
        ],
      ),
    );
  }

  Widget _buildMoreButton(BuildContext context) {
    return PopupMenuButton<_PostMenuAction>(
      icon: const Icon(
        Icons.more_horiz,
        color: AppColor.secondaryText,
        size: 20,
      ),
      padding: EdgeInsets.zero,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: Colors.white,
      elevation: 4,
      offset: const Offset(0, 8),
      onSelected: (action) => _handleAction(context, action),
      itemBuilder: (_) => [
        _menuItem(
          value: _PostMenuAction.copyText,
          icon: Icons.content_copy_rounded,
          label: SocialText.copyPostContent,
          color: AppColor.primaryText,
        ),
        _menuItem(
          value: _PostMenuAction.savePost,
          icon: Icons.bookmark_border_rounded,
          label: SocialText.savePost,
          color: AppColor.primaryText,
        ),
        if (isAuthor) ...[
          const PopupMenuDivider(height: 1),
          _menuItem(
            value: _PostMenuAction.edit,
            icon: Icons.edit_outlined,
            label: SocialText.editPost,
            color: AppColor.primaryText,
          ),
          _menuItem(
            value: _PostMenuAction.delete,
            icon: Icons.delete_outline_rounded,
            label: SocialText.deletePost,
            color: AppColor.alertRed,
          ),
        ] else ...[
          const PopupMenuDivider(height: 1),
          _menuItem(
            value: _PostMenuAction.hide,
            icon: Icons.visibility_off_outlined,
            label: SocialText.hidePost,
            color: AppColor.primaryText,
          ),
          _menuItem(
            value: _PostMenuAction.report,
            icon: Icons.flag_outlined,
            label: SocialText.reportPost,
            color: AppColor.alertRed,
          ),
        ],
      ],
    );
  }

  PopupMenuItem<_PostMenuAction> _menuItem({
    required _PostMenuAction value,
    required IconData icon,
    required String label,
    required Color color,
  }) {
    return PopupMenuItem<_PostMenuAction>(
      value: value,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Row(
        children: [
          Icon(icon, size: 18, color: color),
          const SizedBox(width: 12),
          Text(
            label,
            style: AppTextStyle.bodySmall.copyWith(color: color),
          ),
        ],
      ),
    );
  }

  Future<void> _handleAction(
    BuildContext context,
    _PostMenuAction action,
  ) async {
    switch (action) {
      case _PostMenuAction.copyText:
        await Clipboard.setData(ClipboardData(text: postContent));
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(SocialText.postContentCopied),
              duration: Duration(seconds: 2),
            ),
          );
        }
      case _PostMenuAction.savePost:
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(SocialText.postSaved),
              duration: Duration(seconds: 2),
            ),
          );
        }
      case _PostMenuAction.edit:
        onEditTap?.call();
      case _PostMenuAction.hide:
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(SocialText.postHidden),
              duration: Duration(seconds: 2),
            ),
          );
        }
      case _PostMenuAction.report:
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(SocialText.postReported),
              duration: Duration(seconds: 2),
            ),
          );
        }
      case _PostMenuAction.delete:
        await _confirmDelete(context);
    }
  }

  Future<void> _confirmDelete(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text(SocialText.deletePostTitle),
        content: const Text(SocialText.deletePostBody),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: Text(
              SocialText.cancel,
              style: AppTextStyle.bodySmall.copyWith(
                color: AppColor.secondaryText,
              ),
            ),
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
            child: Text(
              SocialText.delete,
              style: AppTextStyle.bodySmall.copyWith(color: Colors.white),
            ),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      onDeleteConfirmed?.call();
    }
  }

  Widget _buildAvatar() {
    if (authorAvatarUrl != null && authorAvatarUrl!.isNotEmpty) {
      return CircleAvatar(
        radius: 20,
        backgroundColor: AppColor.veryLightGrey,
        backgroundImage: NetworkImage(authorAvatarUrl!),
      );
    }

    return CircleAvatar(
      radius: 20,
      backgroundColor: AppColor.primaryBlue20,
      child: Text(
        authorName.isNotEmpty ? authorName[0].toUpperCase() : '?',
        style: AppTextStyle.bodySmall.copyWith(
          color: AppColor.primaryBlue,
          fontWeight: AppTextStyle.bold,
        ),
      ),
    );
  }
}

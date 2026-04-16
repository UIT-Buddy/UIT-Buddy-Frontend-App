import 'package:flutter/material.dart';
import 'package:uit_buddy_mobile/core/theme/app_color.dart';
import 'package:uit_buddy_mobile/core/theme/app_text_style.dart';
import 'package:uit_buddy_mobile/features/storage/domain/entities/folder_entity.dart';
import 'package:uit_buddy_mobile/features/storage/domain/entities/subject_class_entity.dart';

enum _FolderMenuAction { share, viewSharedUsers }

class StorageFolderWidget extends StatelessWidget {
  const StorageFolderWidget({
    super.key,
    this.classFolder,
    this.subFolder,
    required this.isGrid,
    required this.onTap,
    this.onShare,
    this.onViewSharedUsers,
  }) : assert(classFolder != null || subFolder != null);

  final SubjectClassEntity? classFolder;
  final SubFolderEntity? subFolder;
  final bool isGrid;
  final VoidCallback onTap;
  final VoidCallback? onShare;
  final VoidCallback? onViewSharedUsers;

  @override
  Widget build(BuildContext context) {
    return isGrid
        ? _GridCard(
            classFolder: classFolder,
            subFolder: subFolder,
            onTap: onTap,
            onShare: onShare,
            onViewSharedUsers: onViewSharedUsers,
          )
        : _ListTile(
            classFolder: classFolder,
            subFolder: subFolder,
            onTap: onTap,
            onShare: onShare,
            onViewSharedUsers: onViewSharedUsers,
          );
  }
}

class _GridCard extends StatelessWidget {
  const _GridCard({
    this.classFolder,
    this.subFolder,
    required this.onTap,
    this.onShare,
    this.onViewSharedUsers,
  });

  final SubjectClassEntity? classFolder;
  final SubFolderEntity? subFolder;
  final VoidCallback onTap;
  final VoidCallback? onShare;
  final VoidCallback? onViewSharedUsers;

  @override
  Widget build(BuildContext context) {
    final isClassFolder = classFolder != null;
    final title = isClassFolder
        ? '${classFolder!.classCode} - ${classFolder!.course.courseName}'
        : '${subFolder!.name} (${subFolder!.itemCount})';

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColor.pureWhite,
          borderRadius: BorderRadius.circular(16),
          boxShadow: const [
            BoxShadow(
              color: AppColor.shadowColor,
              blurRadius: 8,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: AppColor.primaryBlue10,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(
                    Icons.folder_outlined,
                    color: AppColor.primaryBlue,
                    size: 22,
                  ),
                ),
                const Spacer(),
                if (subFolder != null &&
                    (onShare != null || onViewSharedUsers != null))
                  _FolderMenuButton(
                    onShare: onShare,
                    onViewSharedUsers: onViewSharedUsers,
                  ),
              ],
            ),
            const Spacer(),
            Text(
              title,
              style: AppTextStyle.bodySmall.copyWith(
                fontWeight: AppTextStyle.medium,
              ),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}

class _ListTile extends StatelessWidget {
  const _ListTile({
    this.classFolder,
    this.subFolder,
    required this.onTap,
    this.onShare,
    this.onViewSharedUsers,
  });

  final SubjectClassEntity? classFolder;
  final SubFolderEntity? subFolder;
  final VoidCallback onTap;
  final VoidCallback? onShare;
  final VoidCallback? onViewSharedUsers;

  @override
  Widget build(BuildContext context) {
    final isClassFolder = classFolder != null;
    final title = isClassFolder
        ? '${classFolder!.classCode} - ${classFolder!.course.courseName}'
        : subFolder!.name;
    final subtitle = isClassFolder ? null : '${subFolder!.itemCount} items';

    return ListTile(
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: AppColor.primaryBlue10,
          borderRadius: BorderRadius.circular(10),
        ),
        child: const Icon(
          Icons.folder_outlined,
          color: AppColor.primaryBlue,
          size: 22,
        ),
      ),
      title: Text(
        title,
        style: AppTextStyle.bodySmall.copyWith(fontWeight: AppTextStyle.medium),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: subtitle != null
          ? Text(subtitle, style: AppTextStyle.captionMedium)
          : null,
      trailing:
          subFolder != null && (onShare != null || onViewSharedUsers != null)
          ? _FolderMenuButton(
              onShare: onShare,
              onViewSharedUsers: onViewSharedUsers,
            )
          : null,
    );
  }
}

class _FolderMenuButton extends StatelessWidget {
  const _FolderMenuButton({
    required this.onShare,
    required this.onViewSharedUsers,
  });

  final VoidCallback? onShare;
  final VoidCallback? onViewSharedUsers;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<_FolderMenuAction>(
      icon: const Icon(
        Icons.more_horiz,
        size: 20,
        color: AppColor.secondaryText,
      ),
      padding: EdgeInsets.zero,
      color: AppColor.pureWhite,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      onSelected: (action) {
        switch (action) {
          case _FolderMenuAction.share:
            onShare?.call();
          case _FolderMenuAction.viewSharedUsers:
            onViewSharedUsers?.call();
        }
      },
      itemBuilder: (_) => [
        const PopupMenuItem<_FolderMenuAction>(
          value: _FolderMenuAction.share,
          child: Row(
            children: [
              Icon(Icons.share_outlined, size: 18, color: AppColor.primaryBlue),
              SizedBox(width: 8),
              Text('Share'),
            ],
          ),
        ),
        const PopupMenuItem<_FolderMenuAction>(
          value: _FolderMenuAction.viewSharedUsers,
          child: Row(
            children: [
              Icon(
                Icons.groups_outlined,
                size: 18,
                color: AppColor.primaryBlue,
              ),
              SizedBox(width: 8),
              Text('View list of shared users'),
            ],
          ),
        ),
      ],
    );
  }
}

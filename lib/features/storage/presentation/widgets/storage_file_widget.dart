import 'package:flutter/material.dart';
import 'package:uit_buddy_mobile/core/theme/app_color.dart';
import 'package:uit_buddy_mobile/core/theme/app_text_style.dart';
import 'package:uit_buddy_mobile/features/storage/domain/entities/document_entity.dart';

enum _FileMenuAction { changeAccess, share, delete }

class StorageFileWidget extends StatelessWidget {
  const StorageFileWidget({
    super.key,
    required this.file,
    required this.isGrid,
    this.onChangeAccess,
    this.onShare,
    this.onDelete,
  });

  final DocumentEntity file;
  final bool isGrid;
  final VoidCallback? onChangeAccess;
  final VoidCallback? onShare;
  final VoidCallback? onDelete;

  @override
  Widget build(BuildContext context) {
    return isGrid
        ? _GridCard(
            file: file,
            onChangeAccess: onChangeAccess,
            onShare: onShare,
            onDelete: onDelete,
          )
        : _ListTile(
            file: file,
            onChangeAccess: onChangeAccess,
            onShare: onShare,
            onDelete: onDelete,
          );
  }
}

_FileTypeConfig _getConfig(String fileName) {
  final ext = fileName.contains('.')
      ? fileName.split('.').last.toLowerCase()
      : '';
  switch (ext) {
    case 'pdf':
      return _FileTypeConfig(
          icon: Icons.picture_as_pdf_outlined, color: AppColor.successGreen);
    case 'pptx':
    case 'ppt':
      return _FileTypeConfig(
          icon: Icons.slideshow_outlined, color: AppColor.warningOrange);
    case 'docx':
    case 'doc':
      return _FileTypeConfig(
          icon: Icons.description_outlined, color: AppColor.primaryBlue);
    case 'txt':
      return _FileTypeConfig(
          icon: Icons.text_snippet_outlined, color: AppColor.secondaryText);
    default:
      return _FileTypeConfig(
          icon: Icons.insert_drive_file_outlined, color: AppColor.primaryBlue);
  }
}

Widget _buildMenu({
  required VoidCallback? onChangeAccess,
  required VoidCallback? onShare,
  required VoidCallback? onDelete,
}) {
  return PopupMenuButton<_FileMenuAction>(
    icon: const Icon(Icons.more_horiz, color: AppColor.secondaryText, size: 20),
    padding: EdgeInsets.zero,
    color: AppColor.pureWhite,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    onSelected: (action) {
      switch (action) {
        case _FileMenuAction.changeAccess:
          onChangeAccess?.call();
        case _FileMenuAction.share:
          onShare?.call();
        case _FileMenuAction.delete:
          onDelete?.call();
      }
    },
    itemBuilder: (_) => [
      PopupMenuItem(
        value: _FileMenuAction.changeAccess,
        child: Row(children: [
          const Icon(Icons.lock_outline, size: 18, color: AppColor.warningOrange),
          const SizedBox(width: 8),
          Text('Change access level', style: AppTextStyle.bodySmall),
        ]),
      ),
      PopupMenuItem(
        value: _FileMenuAction.share,
        child: Row(children: [
          const Icon(Icons.share_outlined, size: 18, color: AppColor.primaryBlue),
          const SizedBox(width: 8),
          Text('Share', style: AppTextStyle.bodySmall),
        ]),
      ),
      PopupMenuItem(
        value: _FileMenuAction.delete,
        child: Row(children: [
          const Icon(Icons.delete_outline, size: 18, color: AppColor.alertRed),
          const SizedBox(width: 8),
          Text(
            'Delete',
            style: AppTextStyle.bodySmall
                .copyWith(color: AppColor.alertRed),
          ),
        ]),
      ),
    ],
  );
}

// ── Grid card ─────────────────────────────────────────────────────────────────

class _GridCard extends StatelessWidget {
  const _GridCard({
    required this.file,
    this.onChangeAccess,
    this.onShare,
    this.onDelete,
  });

  final DocumentEntity file;
  final VoidCallback? onChangeAccess;
  final VoidCallback? onShare;
  final VoidCallback? onDelete;

  @override
  Widget build(BuildContext context) {
    final config = _getConfig(file.fileName);
    return Container(
      padding: const EdgeInsets.fromLTRB(12, 12, 4, 12),
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: config.color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(config.icon, color: config.color, size: 22),
              ),
              const Spacer(),
              _buildMenu(
                onChangeAccess: onChangeAccess,
                onShare: onShare,
                onDelete: onDelete,
              ),
            ],
          ),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: Text(
              file.fileName,
              style: AppTextStyle.bodySmall
                  .copyWith(fontWeight: AppTextStyle.medium),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}

// ── List tile ─────────────────────────────────────────────────────────────────

class _ListTile extends StatelessWidget {
  const _ListTile({
    required this.file,
    this.onChangeAccess,
    this.onShare,
    this.onDelete,
  });

  final DocumentEntity file;
  final VoidCallback? onChangeAccess;
  final VoidCallback? onShare;
  final VoidCallback? onDelete;

  @override
  Widget build(BuildContext context) {
    final config = _getConfig(file.fileName);
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: config.color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(config.icon, color: config.color, size: 22),
      ),
      title: Text(
        file.fileName,
        style:
            AppTextStyle.bodySmall.copyWith(fontWeight: AppTextStyle.medium),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: Text(
        file.classCode,
        style: AppTextStyle.captionMedium,
      ),
      trailing: _buildMenu(
        onChangeAccess: onChangeAccess,
        onShare: onShare,
        onDelete: onDelete,
      ),
    );
  }
}

// ── Helpers ───────────────────────────────────────────────────────────────────

class _FileTypeConfig {
  const _FileTypeConfig({required this.icon, required this.color});

  final IconData icon;
  final Color color;
}

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:uit_buddy_mobile/core/theme/app_color.dart';
import 'package:uit_buddy_mobile/core/theme/app_text_style.dart';
import 'package:uit_buddy_mobile/features/storage/domain/entities/file_entity.dart';

enum _FileMenuAction { rename, move, share, viewSharedUsers, download, delete }

class StorageFileWidget extends StatelessWidget {
  const StorageFileWidget({
    super.key,
    required this.file,
    required this.isGrid,
    this.onRename,
    this.onMove,
    this.onShare,
    this.onViewSharedUsers,
    this.onDelete,
    this.onDownload,
    this.onTap,
  });

  final FileEntity file;
  final bool isGrid;
  final VoidCallback? onRename;
  final VoidCallback? onMove;
  final VoidCallback? onShare;
  final VoidCallback? onViewSharedUsers;
  final VoidCallback? onDelete;
  final VoidCallback? onDownload;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return isGrid
        ? _GridCard(
            file: file,
            onRename: onRename,
            onMove: onMove,
            onShare: onShare,
            onViewSharedUsers: onViewSharedUsers,
            onDelete: onDelete,
            onDownload: onDownload,
            onTap: onTap,
          )
        : _ListTile(
            file: file,
            onRename: onRename,
            onMove: onMove,
            onShare: onShare,
            onViewSharedUsers: onViewSharedUsers,
            onDelete: onDelete,
            onDownload: onDownload,
            onTap: onTap,
          );
  }
}

bool _isImageFile(FileEntity file) {
  if (file.type == FileType.image) {
    return true;
  }

  final ext = file.name.contains('.')
      ? file.name.split('.').last.toLowerCase()
      : '';
  return ['jpg', 'jpeg', 'png', 'gif', 'webp', 'bmp'].contains(ext);
}

bool _hasPreviewableUrl(String url) {
  final uri = Uri.tryParse(url);
  if (uri == null) {
    return false;
  }

  return uri.scheme == 'http' || uri.scheme == 'https';
}

_FileTypeConfig _getConfig(String fileName) {
  final ext = fileName.contains('.')
      ? fileName.split('.').last.toLowerCase()
      : '';
  switch (ext) {
    case 'pdf':
      return _FileTypeConfig(
        icon: Icons.picture_as_pdf_outlined,
        color: AppColor.successGreen,
      );
    case 'pptx':
    case 'ppt':
      return _FileTypeConfig(
        icon: Icons.slideshow_outlined,
        color: AppColor.warningOrange,
      );
    case 'docx':
    case 'doc':
      return _FileTypeConfig(
        icon: Icons.description_outlined,
        color: AppColor.primaryBlue,
      );
    case 'jpg':
    case 'jpeg':
    case 'png':
    case 'gif':
      return _FileTypeConfig(
        icon: Icons.image_outlined,
        color: const Color(0xFF9C27B0),
      );
    case 'mp4':
    case 'avi':
    case 'mkv':
      return _FileTypeConfig(
        icon: Icons.videocam_outlined,
        color: const Color(0xFFFF9800),
      );
    case 'txt':
      return _FileTypeConfig(
        icon: Icons.text_snippet_outlined,
        color: AppColor.secondaryText,
      );
    default:
      return _FileTypeConfig(
        icon: Icons.insert_drive_file_outlined,
        color: AppColor.primaryBlue,
      );
  }
}

Widget _buildMenu({
  required VoidCallback? onRename,
  required VoidCallback? onMove,
  required VoidCallback? onShare,
  required VoidCallback? onViewSharedUsers,
  required VoidCallback? onDownload,
  required VoidCallback? onDelete,
  Color iconColor = AppColor.secondaryText,
}) {
  return PopupMenuButton<_FileMenuAction>(
    icon: Icon(Icons.more_horiz, color: iconColor, size: 20),
    padding: EdgeInsets.zero,
    color: AppColor.pureWhite,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    onSelected: (action) {
      switch (action) {
        case _FileMenuAction.rename:
          onRename?.call();
        case _FileMenuAction.move:
          onMove?.call();
        case _FileMenuAction.share:
          onShare?.call();
        case _FileMenuAction.viewSharedUsers:
          onViewSharedUsers?.call();
        case _FileMenuAction.download:
          onDownload?.call();
        case _FileMenuAction.delete:
          onDelete?.call();
      }
    },
    itemBuilder: (_) => [
      PopupMenuItem(
        value: _FileMenuAction.rename,
        child: Row(
          children: [
            const Icon(
              Icons.drive_file_rename_outline,
              size: 18,
              color: AppColor.primaryBlue,
            ),
            const SizedBox(width: 8),
            Text('Rename', style: AppTextStyle.bodySmall),
          ],
        ),
      ),
      PopupMenuItem(
        value: _FileMenuAction.move,
        child: Row(
          children: [
            const Icon(
              Icons.drive_file_move_outline,
              size: 18,
              color: AppColor.primaryBlue,
            ),
            const SizedBox(width: 8),
            Text('Move', style: AppTextStyle.bodySmall),
          ],
        ),
      ),
      PopupMenuItem(
        value: _FileMenuAction.share,
        child: Row(
          children: [
            const Icon(
              Icons.share_outlined,
              size: 18,
              color: AppColor.primaryBlue,
            ),
            const SizedBox(width: 8),
            Text('Share', style: AppTextStyle.bodySmall),
          ],
        ),
      ),
      PopupMenuItem(
        value: _FileMenuAction.viewSharedUsers,
        child: Row(
          children: [
            const Icon(
              Icons.groups_outlined,
              size: 18,
              color: AppColor.primaryBlue,
            ),
            const SizedBox(width: 8),
            Text('View list of shared users', style: AppTextStyle.bodySmall),
          ],
        ),
      ),
      PopupMenuItem(
        value: _FileMenuAction.download,
        child: Row(
          children: [
            const Icon(
              Icons.download_outlined,
              size: 18,
              color: AppColor.primaryBlue,
            ),
            const SizedBox(width: 8),
            Text('Download', style: AppTextStyle.bodySmall),
          ],
        ),
      ),
      PopupMenuItem(
        value: _FileMenuAction.delete,
        child: Row(
          children: [
            const Icon(
              Icons.delete_outline,
              size: 18,
              color: AppColor.alertRed,
            ),
            const SizedBox(width: 8),
            Text(
              'Delete',
              style: AppTextStyle.bodySmall.copyWith(color: AppColor.alertRed),
            ),
          ],
        ),
      ),
    ],
  );
}

Widget _buildFileLeading(FileEntity file) {
  final config = _getConfig(file.name);
  final shouldPreviewImage = _isImageFile(file) && _hasPreviewableUrl(file.url);

  return Container(
    width: 40,
    height: 40,
    decoration: BoxDecoration(
      color: config.color.withValues(alpha: 0.1),
      borderRadius: BorderRadius.circular(10),
    ),
    clipBehavior: Clip.antiAlias,
    child: shouldPreviewImage
        ? CachedNetworkImage(
            imageUrl: file.url,
            fit: BoxFit.cover,
            placeholder: (_, _) => const Center(
              child: SizedBox(
                width: 16,
                height: 16,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            ),
            errorWidget: (_, _, _) =>
                Icon(config.icon, color: config.color, size: 22),
          )
        : Icon(config.icon, color: config.color, size: 22),
  );
}

Widget _buildPreviewFallbackIcon(FileEntity file) {
  final config = _getConfig(file.name);
  return Center(
    child: Icon(
      config.icon,
      color: AppColor.pureWhite.withValues(alpha: 0.9),
      size: 34,
    ),
  );
}

class _ImageGridCard extends StatelessWidget {
  const _ImageGridCard({
    required this.file,
    this.onRename,
    this.onMove,
    this.onShare,
    this.onViewSharedUsers,
    this.onDelete,
    this.onDownload,
    this.onTap,
  });

  final FileEntity file;
  final VoidCallback? onRename;
  final VoidCallback? onMove;
  final VoidCallback? onShare;
  final VoidCallback? onViewSharedUsers;
  final VoidCallback? onDelete;
  final VoidCallback? onDownload;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: Colors.black12,
          boxShadow: const [
            BoxShadow(
              color: AppColor.shadowColor,
              blurRadius: 8,
              offset: Offset(0, 2),
            ),
          ],
        ),
        clipBehavior: Clip.antiAlias,
        child: Stack(
          children: [
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.black.withValues(alpha: 0.28),
                      Colors.black.withValues(alpha: 0.08),
                      Colors.black.withValues(alpha: 0.56),
                    ],
                    stops: const [0.0, 0.35, 1.0],
                  ),
                ),
              ),
            ),
            Positioned.fill(
              child: CachedNetworkImage(
                imageUrl: file.url,
                fit: BoxFit.cover,
                errorWidget: (_, _, _) => _buildPreviewFallbackIcon(file),
                placeholder: (_, _) => const SizedBox.shrink(),
              ),
            ),
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.black.withValues(alpha: 0.28),
                      Colors.transparent,
                      Colors.black.withValues(alpha: 0.62),
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              top: 6,
              right: 4,
              child: _buildMenu(
                onRename: onRename,
                onMove: onMove,
                onShare: onShare,
                onViewSharedUsers: onViewSharedUsers,
                onDownload: onDownload,
                onDelete: onDelete,
                iconColor: AppColor.pureWhite,
              ),
            ),
            Positioned(
              left: 10,
              right: 10,
              bottom: 10,
              child: Container(
                padding: const EdgeInsets.fromLTRB(8, 8, 8, 6),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.28),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      file.name,
                      style: AppTextStyle.bodySmall.copyWith(
                        color: AppColor.pureWhite,
                        fontWeight: AppTextStyle.medium,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${file.size} ${file.sizeUnit}',
                      style: AppTextStyle.captionSmall.copyWith(
                        color: AppColor.pureWhite.withValues(alpha: 0.9),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ImageListTile extends StatelessWidget {
  const _ImageListTile({
    required this.file,
    this.onRename,
    this.onMove,
    this.onShare,
    this.onViewSharedUsers,
    this.onDelete,
    this.onDownload,
    this.onTap,
  });

  final FileEntity file;
  final VoidCallback? onRename;
  final VoidCallback? onMove;
  final VoidCallback? onShare;
  final VoidCallback? onViewSharedUsers;
  final VoidCallback? onDelete;
  final VoidCallback? onDownload;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 74,
        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          color: Colors.black12,
        ),
        clipBehavior: Clip.antiAlias,
        child: Stack(
          children: [
            Positioned.fill(
              child: CachedNetworkImage(
                imageUrl: file.url,
                fit: BoxFit.cover,
                errorWidget: (_, _, _) => _buildPreviewFallbackIcon(file),
                placeholder: (_, _) => const SizedBox.shrink(),
              ),
            ),
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: [
                      Colors.black.withValues(alpha: 0.58),
                      Colors.black.withValues(alpha: 0.24),
                      Colors.black.withValues(alpha: 0.48),
                    ],
                    stops: const [0.0, 0.55, 1.0],
                  ),
                ),
              ),
            ),
            Positioned(
              left: 12,
              right: 8,
              top: 8,
              bottom: 8,
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          file.name,
                          style: AppTextStyle.bodySmall.copyWith(
                            color: AppColor.pureWhite,
                            fontWeight: AppTextStyle.medium,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 2),
                        Text(
                          '${file.size} ${file.sizeUnit}',
                          style: AppTextStyle.captionSmall.copyWith(
                            color: AppColor.pureWhite.withValues(alpha: 0.9),
                          ),
                        ),
                      ],
                    ),
                  ),
                  _buildMenu(
                    onRename: onRename,
                    onMove: onMove,
                    onShare: onShare,
                    onViewSharedUsers: onViewSharedUsers,
                    onDownload: onDownload,
                    onDelete: onDelete,
                    iconColor: AppColor.pureWhite,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Grid card ─────────────────────────────────────────────────────────────────

class _GridCard extends StatelessWidget {
  const _GridCard({
    required this.file,
    this.onRename,
    this.onMove,
    this.onShare,
    this.onViewSharedUsers,
    this.onDelete,
    this.onDownload,
    this.onTap,
  });

  final FileEntity file;
  final VoidCallback? onRename;
  final VoidCallback? onMove;
  final VoidCallback? onShare;
  final VoidCallback? onViewSharedUsers;
  final VoidCallback? onDelete;
  final VoidCallback? onDownload;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final isImagePreview = _isImageFile(file) && _hasPreviewableUrl(file.url);
    if (isImagePreview) {
      return _ImageGridCard(
        file: file,
        onRename: onRename,
        onMove: onMove,
        onShare: onShare,
        onViewSharedUsers: onViewSharedUsers,
        onDelete: onDelete,
        onDownload: onDownload,
        onTap: onTap,
      );
    }

    return GestureDetector(
      onTap: onTap,
      child: Container(
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
                _buildFileLeading(file),
                const Spacer(),
                _buildMenu(
                  onRename: onRename,
                  onMove: onMove,
                  onShare: onShare,
                  onViewSharedUsers: onViewSharedUsers,
                  onDownload: onDownload,
                  onDelete: onDelete,
                ),
              ],
            ),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    file.name,
                    style: AppTextStyle.bodySmall.copyWith(
                      fontWeight: AppTextStyle.medium,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${file.size} ${file.sizeUnit}',
                    style: AppTextStyle.captionSmall.copyWith(
                      color: AppColor.secondaryText,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── List tile ─────────────────────────────────────────────────────────────────

class _ListTile extends StatelessWidget {
  const _ListTile({
    required this.file,
    this.onRename,
    this.onMove,
    this.onShare,
    this.onViewSharedUsers,
    this.onDelete,
    this.onDownload,
    this.onTap,
  });

  final FileEntity file;
  final VoidCallback? onRename;
  final VoidCallback? onMove;
  final VoidCallback? onShare;
  final VoidCallback? onViewSharedUsers;
  final VoidCallback? onDelete;
  final VoidCallback? onDownload;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final isImagePreview = _isImageFile(file) && _hasPreviewableUrl(file.url);
    if (isImagePreview) {
      return _ImageListTile(
        file: file,
        onRename: onRename,
        onMove: onMove,
        onShare: onShare,
        onViewSharedUsers: onViewSharedUsers,
        onDelete: onDelete,
        onDownload: onDownload,
        onTap: onTap,
      );
    }

    return GestureDetector(
      onTap: onTap,
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        leading: _buildFileLeading(file),
        title: Text(
          file.name,
          style: AppTextStyle.bodySmall.copyWith(
            fontWeight: AppTextStyle.medium,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Text(
          '${file.size} ${file.sizeUnit}',
          style: AppTextStyle.captionSmall.copyWith(
            color: AppColor.secondaryText,
          ),
        ),
        trailing: _buildMenu(
          onRename: onRename,
          onMove: onMove,
          onShare: onShare,
          onViewSharedUsers: onViewSharedUsers,
          onDownload: onDownload,
          onDelete: onDelete,
        ),
        onTap: onTap,
      ),
    );
  }
}

class _FileTypeConfig {
  final IconData icon;
  final Color color;

  _FileTypeConfig({required this.icon, required this.color});
}

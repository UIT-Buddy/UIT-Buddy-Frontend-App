import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uit_buddy_mobile/core/theme/app_color.dart';
import 'package:uit_buddy_mobile/features/storage/domain/entities/file_entity.dart'
    as file_entity
    show FileEntity;
import 'package:uit_buddy_mobile/features/storage/domain/entities/folder_entity.dart';
import 'package:uit_buddy_mobile/features/storage/presentation/bloc/storage_bloc.dart';
import 'package:uit_buddy_mobile/features/storage/presentation/bloc/storage_event.dart';
import 'package:uit_buddy_mobile/features/storage/presentation/widgets/storage_add_file_button.dart';
import 'package:uit_buddy_mobile/features/storage/presentation/widgets/storage_file_widget.dart';
import 'package:uit_buddy_mobile/features/storage/presentation/widgets/storage_folder_widget.dart';

class StorageFileGrid extends StatelessWidget {
  const StorageFileGrid({
    super.key,
    required this.folder,
    required this.isMoveMode,
    required this.onOpenFile,
    required this.onRename,
    required this.onMove,
    required this.onDelete,
    required this.onDownload,
    required this.onShareFile,
    required this.onViewSharedUsersFile,
    required this.onShareFolder,
    required this.onViewSharedUsersFolder,
    this.onAddTap,
  });

  final FolderEntity folder;
  final bool isMoveMode;
  final ValueChanged<file_entity.FileEntity> onOpenFile;
  final ValueChanged<file_entity.FileEntity> onRename;
  final ValueChanged<file_entity.FileEntity> onMove;
  final ValueChanged<file_entity.FileEntity> onDelete;
  final ValueChanged<file_entity.FileEntity> onDownload;
  final ValueChanged<file_entity.FileEntity> onShareFile;
  final ValueChanged<file_entity.FileEntity> onViewSharedUsersFile;
  final ValueChanged<SubFolderEntity> onShareFolder;
  final ValueChanged<SubFolderEntity> onViewSharedUsersFolder;
  final VoidCallback? onAddTap;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
      physics: const AlwaysScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 1.0,
      ),
      itemCount:
          folder.files.length + folder.folders.length + (isMoveMode ? 0 : 1),
      itemBuilder: (context, index) {
        if (index < folder.folders.length) {
          final subFolder = folder.folders[index];
          return StorageFolderWidget(
            subFolder: subFolder,
            isGrid: true,
            onTap: () => context.read<StorageBloc>().add(
              StorageFolderOpened(folderId: subFolder.id),
            ),
            onShare: () => onShareFolder(subFolder),
            onViewSharedUsers: () => onViewSharedUsersFolder(subFolder),
          );
        }

        final fileIndex = index - folder.folders.length;
        if (fileIndex < folder.files.length) {
          final file = folder.files[fileIndex];
          return StorageFileWidget(
            file: file,
            isGrid: true,
            onRename: () => onRename(file),
            onMove: () => onMove(file),
            onShare: () => onShareFile(file),
            onViewSharedUsers: () => onViewSharedUsersFile(file),
            onDelete: () => onDelete(file),
            onTap: () => onOpenFile(file),
            onDownload: () => onDownload(file),
          );
        }

        return StorageAddFileButton(isGrid: true, onTap: onAddTap!);
      },
    );
  }
}

class StorageFileList extends StatelessWidget {
  const StorageFileList({
    super.key,
    required this.folder,
    required this.isMoveMode,
    required this.onOpenFile,
    required this.onRename,
    required this.onMove,
    required this.onDelete,
    required this.onDownload,
    required this.onShareFile,
    required this.onViewSharedUsersFile,
    required this.onShareFolder,
    required this.onViewSharedUsersFolder,
    this.onAddTap,
  });

  final FolderEntity folder;
  final bool isMoveMode;
  final ValueChanged<file_entity.FileEntity> onOpenFile;
  final ValueChanged<file_entity.FileEntity> onRename;
  final ValueChanged<file_entity.FileEntity> onMove;
  final ValueChanged<file_entity.FileEntity> onDelete;
  final ValueChanged<file_entity.FileEntity> onDownload;
  final ValueChanged<file_entity.FileEntity> onShareFile;
  final ValueChanged<file_entity.FileEntity> onViewSharedUsersFile;
  final ValueChanged<SubFolderEntity> onShareFolder;
  final ValueChanged<SubFolderEntity> onViewSharedUsersFolder;
  final VoidCallback? onAddTap;

  @override
  Widget build(BuildContext context) {
    final items = [...folder.folders, ...folder.files];
    return ListView.separated(
      padding: const EdgeInsets.symmetric(vertical: 8),
      physics: const AlwaysScrollableScrollPhysics(),
      itemCount: items.length + (isMoveMode ? 0 : 1),
      separatorBuilder: (_, _) =>
          const Divider(height: 1, indent: 72, color: AppColor.dividerGrey),
      itemBuilder: (context, index) {
        if (!isMoveMode && index == items.length) {
          return StorageAddFileButton(isGrid: false, onTap: onAddTap!);
        }

        final item = items[index];
        if (item is SubFolderEntity) {
          return StorageFolderWidget(
            subFolder: item,
            isGrid: false,
            onTap: () => context.read<StorageBloc>().add(
              StorageFolderOpened(folderId: item.id),
            ),
            onShare: () => onShareFolder(item),
            onViewSharedUsers: () => onViewSharedUsersFolder(item),
          );
        }

        final file = item as file_entity.FileEntity;
        return StorageFileWidget(
          file: file,
          isGrid: false,
          onRename: () => onRename(file),
          onMove: () => onMove(file),
          onShare: () => onShareFile(file),
          onViewSharedUsers: () => onViewSharedUsersFile(file),
          onDelete: () => onDelete(file),
          onTap: () => onOpenFile(file),
          onDownload: () => onDownload(file),
        );
      },
    );
  }
}

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:uit_buddy_mobile/core/theme/app_color.dart';
import 'package:uit_buddy_mobile/core/theme/app_text_style.dart';
import 'package:uit_buddy_mobile/features/storage/domain/entities/file_entity.dart'
    as file_entity
    show FileEntity, FileType;
import 'package:uit_buddy_mobile/features/storage/presentation/bloc/storage_bloc.dart';
import 'package:uit_buddy_mobile/features/storage/presentation/bloc/storage_event.dart';

class StorageDialogActions {
  static void showAddDialog(BuildContext context, StorageBloc bloc) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Add Item'),
        content: const Text('What would you like to add?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(dialogContext);
              showCreateFolderDialog(dialogContext, bloc);
            },
            child: const Text('Create Folder'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(dialogContext);
              showUploadFileDialog(dialogContext, bloc);
            },
            child: const Text('Upload File'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }

  static void showCreateFolderDialog(BuildContext context, StorageBloc bloc) {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Create Folder'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            hintText: 'Folder name',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              final folderName = controller.text.trim();
              if (folderName.isNotEmpty) {
                bloc.add(StorageCreateFolder(folderName: folderName));
                Navigator.pop(dialogContext);
              }
            },
            child: const Text('Create'),
          ),
        ],
      ),
    );
  }

  static void showRenameFileDialog(
    BuildContext context,
    file_entity.FileEntity file,
    StorageBloc bloc,
  ) {
    final controller = TextEditingController(text: file.name);

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Rename File'),
        content: TextField(
          controller: controller,
          autofocus: true,
          decoration: const InputDecoration(
            hintText: 'New file name',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              final newName = controller.text.trim();
              if (newName.isEmpty || newName == file.name) {
                Navigator.pop(dialogContext);
                return;
              }

              bloc.add(
                StorageFileRenamed(documentId: file.id, newFileName: newName),
              );
              Navigator.pop(dialogContext);
            },
            child: const Text('Rename'),
          ),
        ],
      ),
    );
  }

  static void showDeleteFileDialog(
    BuildContext context,
    file_entity.FileEntity file,
    StorageBloc bloc,
  ) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Delete File'),
        content: Text(
          'Are you sure you want to delete "${file.name}"? This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              bloc.add(StorageFileDeleted(documentId: file.id));
              Navigator.pop(dialogContext);
            },
            child: Text(
              'Delete',
              style: AppTextStyle.bodyMedium.copyWith(color: AppColor.alertRed),
            ),
          ),
        ],
      ),
    );
  }

  static void showUploadFileDialog(BuildContext context, StorageBloc bloc) {
    final selectedFiles = <PlatformFile>[];

    showDialog(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: const Text('Upload Files'),
          content: SingleChildScrollView(
            child: SizedBox(
              width: double.maxFinite,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (selectedFiles.isEmpty)
                    Column(
                      children: [
                        Icon(
                          Icons.cloud_upload_outlined,
                          size: 48,
                          color: AppColor.secondaryText,
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'No files selected',
                          style: AppTextStyle.bodyMedium,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Tap "Pick Files" to select files to upload',
                          style: AppTextStyle.captionMedium.copyWith(
                            color: AppColor.secondaryText,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    )
                  else
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${selectedFiles.length} file(s) selected:',
                          style: AppTextStyle.bodyMedium.copyWith(
                            fontWeight: AppTextStyle.medium,
                          ),
                        ),
                        const SizedBox(height: 8),
                        ...selectedFiles.map(
                          (file) => Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.attach_file,
                                  size: 16,
                                  color: AppColor.secondaryText,
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    file.name,
                                    style: AppTextStyle.captionMedium,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () async {
                final result = await FilePicker.platform.pickFiles(
                  allowMultiple: true,
                );
                if (result != null) {
                  setState(() {
                    selectedFiles.addAll(result.files);
                  });
                }
              },
              child: const Text('Pick Files'),
            ),
            if (selectedFiles.isNotEmpty)
              TextButton(
                onPressed: () {
                  setState(() {
                    selectedFiles.clear();
                  });
                },
                child: const Text('Clear'),
              ),
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Cancel'),
            ),
            if (selectedFiles.isNotEmpty)
              ElevatedButton(
                onPressed: () {
                  final files = selectedFiles.map((pf) {
                    final sizeMB = pf.size / 1024 / 1024;
                    return file_entity.FileEntity(
                      id: '',
                      name: pf.name,
                      url: pf.path ?? '',
                      size: sizeMB,
                      sizeUnit: 'MB',
                      type: _getFileTypeFromExtension(pf.extension),
                    );
                  }).toList();

                  bloc.add(StorageCreateFiles(files: files));
                  Navigator.pop(dialogContext);
                },
                child: const Text('Upload'),
              ),
          ],
        ),
      ),
    );
  }

  static file_entity.FileType _getFileTypeFromExtension(String? extension) {
    if (extension == null) return file_entity.FileType.other;
    final ext = extension.toLowerCase();
    if (['doc', 'docx', 'word'].contains(ext)) return file_entity.FileType.word;
    if (['jpg', 'jpeg', 'png', 'gif'].contains(ext)) {
      return file_entity.FileType.image;
    }
    if (['mp4', 'mkv', 'avi'].contains(ext)) return file_entity.FileType.video;
    if (['xls', 'xlsx', 'excel'].contains(ext)) {
      return file_entity.FileType.excel;
    }
    if (['ppt', 'pptx', 'presentation'].contains(ext)) {
      return file_entity.FileType.ppt;
    }
    return file_entity.FileType.other;
  }

  static Future<void> openFileUrl(BuildContext context, String url) async {
    final uri = Uri.tryParse(url);
    if (uri == null) {
      showSnackBar(context, 'Invalid file URL.', isError: true);
      return;
    }

    try {
      final launched = await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
      );
      if (!launched && context.mounted) {
        showSnackBar(context, 'Could not open this file.', isError: true);
      }
    } catch (_) {
      if (context.mounted) {
        showSnackBar(context, 'Failed to open this file.', isError: true);
      }
    }
  }

  static void showSnackBar(
    BuildContext context,
    String message, {
    required bool isError,
  }) {
    final messenger = ScaffoldMessenger.of(context);
    messenger
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(message),
          behavior: SnackBarBehavior.floating,
          backgroundColor: isError ? AppColor.alertRed : AppColor.successGreen,
        ),
      );
  }
}

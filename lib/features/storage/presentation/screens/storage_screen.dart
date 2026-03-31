import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:file_picker/file_picker.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:uit_buddy_mobile/app/di/app_dependencies.dart';
import 'package:uit_buddy_mobile/core/theme/app_color.dart';
import 'package:uit_buddy_mobile/core/theme/app_text_style.dart';
import 'package:uit_buddy_mobile/features/storage/domain/entities/file_entity.dart'
    as file_entity
    show FileEntity, FileType;
import 'package:uit_buddy_mobile/features/storage/domain/entities/folder_entity.dart';
import 'package:uit_buddy_mobile/features/storage/presentation/bloc/storage_bloc.dart';
import 'package:uit_buddy_mobile/features/storage/presentation/bloc/storage_event.dart';
import 'package:uit_buddy_mobile/features/storage/presentation/bloc/storage_state.dart';
import 'package:uit_buddy_mobile/features/storage/presentation/screens/storage_file_viewer_screen.dart';
import 'package:uit_buddy_mobile/features/storage/presentation/widgets/storage_add_file_button.dart';
import 'package:uit_buddy_mobile/features/storage/presentation/widgets/storage_file_widget.dart';
import 'package:uit_buddy_mobile/features/storage/presentation/widgets/storage_folder_widget.dart';

class StorageScreen extends StatelessWidget {
  const StorageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => serviceLocator<StorageBloc>()..add(const StorageStarted()),
      child: BlocBuilder<StorageBloc, StorageState>(
        builder: (context, state) {
          final isGrid = state.viewType == StorageViewType.grid;
          final isFolder = state.viewMode == StorageViewMode.folder;

          return Stack(
            children: [
              PopScope(
                canPop: !isFolder,
                onPopInvokedWithResult: (didPop, _) {
                  if (!didPop && isFolder) {
                    context.read<StorageBloc>().add(const StorageBackPressed());
                  }
                },
                child: Scaffold(
                  backgroundColor: AppColor.veryLightGrey,
                  body: SafeArea(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // ── Header ──────────────────────────────────────────────
                        Padding(
                          padding: const EdgeInsets.fromLTRB(20, 16, 16, 8),
                          child: Row(
                            children: [
                              Text(
                                'Storage',
                                style: AppTextStyle.h1.copyWith(
                                  fontWeight: AppTextStyle.bold,
                                ),
                              ),
                              const Spacer(),
                              _ViewTypeToggle(
                                isGrid: isGrid,
                                onToggle: () => context.read<StorageBloc>().add(
                                  const StorageViewTypeToggled(),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Text(
                                isFolder
                                    ? '${(state.currentFolder?.files.length ?? 0) + (state.currentFolder?.folders.length ?? 0)} items'
                                    : '${state.classes.length} items',
                                style: AppTextStyle.captionMedium.copyWith(
                                  color: AppColor.secondaryText,
                                ),
                              ),
                            ],
                          ),
                        ),

                        // ── Breadcrumb (not at top level) ────────────────────────
                        if (state.currentFolder != null &&
                            state.folderStack.length > 1)
                          Padding(
                            padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
                            child: Row(
                              children: [
                                // GestureDetector(
                                //   onTap: () => context.read<StorageBloc>().add(
                                //     const StorageBackPressed(),
                                //   ),
                                //   child: Text(
                                //     'Storage',
                                //     style: AppTextStyle.captionMedium.copyWith(
                                //       color: AppColor.primaryBlue,
                                //     ),
                                //   ),
                                // ),
                                Expanded(
                                  child: Text(
                                    state.currentFolder!.path,
                                    style: AppTextStyle.captionMedium.copyWith(
                                      color: AppColor.secondaryText,
                                      fontWeight: AppTextStyle.medium,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                GestureDetector(
                                  onTap: () => context.read<StorageBloc>().add(
                                    const StorageBackPressed(),
                                  ),
                                  child: const Icon(
                                    Icons.arrow_back,
                                    color: AppColor.secondaryText,
                                    size: 20,
                                  ),
                                ),
                              ],
                            ),
                          ),

                        // ── Content ─────────────────────────────────────────────
                        Expanded(
                          child: _buildContent(
                            context,
                            state,
                            isGrid,
                            isFolder,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              // Loading overlay
              if (state.isCreating)
                Container(
                  color: Colors.black.withValues(alpha: 0.4),
                  child: const Center(child: CircularProgressIndicator()),
                ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildContent(
    BuildContext context,
    StorageState state,
    bool isGrid,
    bool isFolder,
  ) {
    if (state.isFolderLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (state.errorMessage != null && state.currentFolder == null) {
      return Center(
        child: Text(state.errorMessage!, style: AppTextStyle.bodyMedium),
      );
    }
    final folder = state.currentFolder;
    if (folder == null) {
      return const Center(child: CircularProgressIndicator());
    }
    return isGrid
        ? _FileGrid(state: state, folder: folder)
        : _FileList(state: state, folder: folder);
  }

  static void _showAddDialog(
    BuildContext context,
    FolderEntity folder,
    StorageBloc bloc,
  ) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Add Item'),
        content: const Text('What would you like to add?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(dialogContext);
              _showCreateFolderDialog(dialogContext, folder, bloc);
            },
            child: const Text('Create Folder'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(dialogContext);
              _showUploadFileDialog(dialogContext, folder, bloc);
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

  static void _showCreateFolderDialog(
    BuildContext context,
    FolderEntity folder,
    StorageBloc bloc,
  ) {
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

  static void _showUploadFileDialog(
    BuildContext context,
    FolderEntity folder,
    StorageBloc bloc,
  ) {
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
                  // Convert PlatformFile to FileEntity and upload
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
}

// ── File grid ─────────────────────────────────────────────────────────────────

class _FileGrid extends StatelessWidget {
  const _FileGrid({required this.state, required this.folder});

  final StorageState state;
  final FolderEntity folder;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 1.0,
      ),
      itemCount: folder.files.length + folder.folders.length + 1,
      itemBuilder: (context, index) {
        if (index < folder.folders.length) {
          final subFolder = folder.folders[index];
          return StorageFolderWidget(
            subFolder: subFolder,
            isGrid: true,
            onTap: () => context.read<StorageBloc>().add(
              StorageFolderOpened(folderId: subFolder.id),
            ),
          );
        }

        final fileIndex = index - folder.folders.length;
        if (fileIndex < folder.files.length) {
          final file = folder.files[fileIndex];
          return StorageFileWidget(
            file: file,
            isGrid: true,
            onChangeAccess: () {},
            onShare: () {},
            onDelete: () {},
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => StorageFileViewerScreen(file: file),
              ),
            ),
            onDownload: () async {
              if (await canLaunchUrl(Uri.parse(file.url))) {
                await launchUrl(Uri.parse(file.url));
              }
            },
          );
        }

        return StorageAddFileButton(
          isGrid: true,
          onTap: () {
            final bloc = context.read<StorageBloc>();
            StorageScreen._showAddDialog(context, folder, bloc);
          },
        );
      },
    );
  }
}

// ── File list ─────────────────────────────────────────────────────────────────

class _FileList extends StatelessWidget {
  const _FileList({required this.state, required this.folder});

  final StorageState state;
  final FolderEntity folder;

  @override
  Widget build(BuildContext context) {
    final items = [...folder.folders, ...folder.files];
    return ListView.separated(
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemCount: items.length + 1,
      separatorBuilder: (_, _) =>
          const Divider(height: 1, indent: 72, color: AppColor.dividerGrey),
      itemBuilder: (context, index) {
        if (index == items.length) {
          return StorageAddFileButton(
            isGrid: false,
            onTap: () {
              final bloc = context.read<StorageBloc>();
              StorageScreen._showAddDialog(context, folder, bloc);
            },
          );
        }

        final item = items[index];
        if (item is SubFolderEntity) {
          return StorageFolderWidget(
            subFolder: item,
            isGrid: false,
            onTap: () => context.read<StorageBloc>().add(
              StorageFolderOpened(folderId: item.id),
            ),
          );
        }

        final file = item as file_entity.FileEntity;
        return StorageFileWidget(
          file: file,
          isGrid: false,
          onChangeAccess: () {},
          onShare: () {},
          onDelete: () {},
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => StorageFileViewerScreen(file: file),
            ),
          ),
          onDownload: () async {
            if (await canLaunchUrl(Uri.parse(file.url))) {
              await launchUrl(Uri.parse(file.url));
            }
          },
        );
      },
    );
  }
}

// ── View-type toggle ──────────────────────────────────────────────────────────

class _ViewTypeToggle extends StatelessWidget {
  const _ViewTypeToggle({required this.isGrid, required this.onToggle});

  final bool isGrid;
  final VoidCallback onToggle;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColor.dividerGrey,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _ToggleButton(
            icon: Icons.grid_view_rounded,
            selected: isGrid,
            onTap: isGrid ? null : onToggle,
          ),
          _ToggleButton(
            icon: Icons.format_list_bulleted_rounded,
            selected: !isGrid,
            onTap: !isGrid ? null : onToggle,
          ),
        ],
      ),
    );
  }
}

class _ToggleButton extends StatelessWidget {
  const _ToggleButton({required this.icon, required this.selected, this.onTap});

  final IconData icon;
  final bool selected;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          color: selected ? AppColor.pureWhite : Colors.transparent,
          borderRadius: BorderRadius.circular(6),
          boxShadow: selected
              ? const [BoxShadow(color: AppColor.shadowColor, blurRadius: 4)]
              : null,
        ),
        child: Icon(
          icon,
          size: 18,
          color: selected ? AppColor.primaryBlue : AppColor.secondaryText,
        ),
      ),
    );
  }
}

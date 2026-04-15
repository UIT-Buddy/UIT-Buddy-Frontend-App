import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uit_buddy_mobile/app/di/app_dependencies.dart';
import 'package:uit_buddy_mobile/core/theme/app_color.dart';
import 'package:uit_buddy_mobile/core/theme/app_text_style.dart';
import 'package:uit_buddy_mobile/features/storage/domain/entities/file_entity.dart'
    as file_entity
    show FileEntity;
import 'package:uit_buddy_mobile/features/storage/domain/entities/folder_entity.dart';
import 'package:uit_buddy_mobile/features/storage/presentation/bloc/storage_bloc.dart';
import 'package:uit_buddy_mobile/features/storage/presentation/bloc/storage_event.dart';
import 'package:uit_buddy_mobile/features/storage/presentation/bloc/storage_state.dart';
import 'package:uit_buddy_mobile/features/storage/presentation/screens/storage_access_management_screen.dart';
import 'package:uit_buddy_mobile/features/storage/presentation/screens/storage_file_viewer_screen.dart';
import 'package:uit_buddy_mobile/features/storage/presentation/widgets/storage_screen/storage_dialog_actions.dart';
import 'package:uit_buddy_mobile/features/storage/presentation/widgets/storage_screen/storage_file_views.dart';
import 'package:uit_buddy_mobile/features/storage/presentation/widgets/storage_screen/storage_header.dart';
import 'package:uit_buddy_mobile/features/storage/presentation/widgets/storage_screen/storage_move_mode_banner.dart';

class StorageScreen extends StatelessWidget {
  const StorageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => serviceLocator<StorageBloc>()..add(const StorageStarted()),
      child: BlocConsumer<StorageBloc, StorageState>(
        listenWhen: (previous, current) =>
            previous.actionErrorMessage != current.actionErrorMessage ||
            previous.actionSuccessMessage != current.actionSuccessMessage,
        listener: (context, state) {
          final message =
              state.actionErrorMessage ?? state.actionSuccessMessage;
          if (message == null) {
            return;
          }

          StorageDialogActions.showSnackBar(
            context,
            message,
            isError: state.actionErrorMessage != null,
          );
          context.read<StorageBloc>().add(const StorageFeedbackCleared());
        },
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
                        StorageScreenHeader(
                          isGrid: isGrid,
                          itemCount: isFolder
                              ? (state.currentFolder?.files.length ?? 0) +
                                    (state.currentFolder?.folders.length ?? 0)
                              : state.classes.length,
                          onToggleViewType: () => context
                              .read<StorageBloc>()
                              .add(const StorageViewTypeToggled()),
                        ),
                        if (state.currentFolder != null &&
                            state.folderStack.length > 1)
                          StorageFolderBreadcrumb(
                            path: state.currentFolder!.path,
                            onBack: () => context.read<StorageBloc>().add(
                              const StorageBackPressed(),
                            ),
                          ),
                        if (state.isMoveMode && state.movingFile != null)
                          Padding(
                            padding: const EdgeInsets.fromLTRB(16, 0, 16, 10),
                            child: StorageMoveModeBanner(
                              fileName: state.movingFile!.name,
                              canMoveHere:
                                  state.currentFolder != null &&
                                  state.currentFolder!.id !=
                                      state.moveSourceFolderId &&
                                  !state.isCreating,
                              onCancel: () => context.read<StorageBloc>().add(
                                const StorageMoveCancelled(),
                              ),
                              onMoveHere: () => context.read<StorageBloc>().add(
                                const StorageMoveConfirmed(),
                              ),
                            ),
                          ),
                        Expanded(child: _buildContent(context, state, isGrid)),
                      ],
                    ),
                  ),
                ),
              ),
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

  Widget _buildContent(BuildContext context, StorageState state, bool isGrid) {
    if (state.isFolderLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state.errorMessage != null && state.currentFolder == null) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(state.errorMessage!, style: AppTextStyle.bodyMedium),
            const SizedBox(height: 12),
            TextButton(
              onPressed: () =>
                  context.read<StorageBloc>().add(const StorageStarted()),
              child: const Text('Try again'),
            ),
          ],
        ),
      );
    }

    final folder = state.currentFolder;
    if (folder == null) {
      return const Center(child: CircularProgressIndicator());
    }

    final bloc = context.read<StorageBloc>();

    void onOpenFile(file_entity.FileEntity file) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => StorageFileViewerScreen(file: file)),
      );
    }

    void onRename(file_entity.FileEntity file) {
      StorageDialogActions.showRenameFileDialog(context, file, bloc);
    }

    void onDelete(file_entity.FileEntity file) {
      StorageDialogActions.showDeleteFileDialog(context, file, bloc);
    }

    void onMove(file_entity.FileEntity file) {
      bloc.add(StorageMoveStarted(file: file));
    }

    void onDownload(file_entity.FileEntity file) {
      StorageDialogActions.openFileUrl(context, file.url);
    }

    Future<void> onShareFile(file_entity.FileEntity file) async {
      await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => StorageAccessManagementScreen(
            resourceId: file.id,
            resourceName: file.name,
            resourceType: StorageShareResourceType.document,
            mode: StorageShareActionMode.share,
          ),
        ),
      );
    }

    Future<void> onViewSharedUsersFile(file_entity.FileEntity file) async {
      await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => StorageAccessManagementScreen(
            resourceId: file.id,
            resourceName: file.name,
            resourceType: StorageShareResourceType.document,
            mode: StorageShareActionMode.manageSharedUsers,
          ),
        ),
      );
    }

    Future<void> onShareFolder(SubFolderEntity folder) async {
      await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => StorageAccessManagementScreen(
            resourceId: folder.id,
            resourceName: folder.name,
            resourceType: StorageShareResourceType.folder,
            mode: StorageShareActionMode.share,
          ),
        ),
      );
    }

    Future<void> onViewSharedUsersFolder(SubFolderEntity folder) async {
      await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => StorageAccessManagementScreen(
            resourceId: folder.id,
            resourceName: folder.name,
            resourceType: StorageShareResourceType.folder,
            mode: StorageShareActionMode.manageSharedUsers,
          ),
        ),
      );
    }

    final onAddTap = state.isMoveMode
        ? null
        : () {
            StorageDialogActions.showAddDialog(context, bloc);
          };

    final content = isGrid
        ? StorageFileGrid(
            folder: folder,
            isMoveMode: state.isMoveMode,
            onAddTap: onAddTap,
            onOpenFile: onOpenFile,
            onRename: onRename,
            onDelete: onDelete,
            onMove: onMove,
            onDownload: onDownload,
            onShareFile: onShareFile,
            onViewSharedUsersFile: onViewSharedUsersFile,
            onShareFolder: onShareFolder,
            onViewSharedUsersFolder: onViewSharedUsersFolder,
          )
        : StorageFileList(
            folder: folder,
            isMoveMode: state.isMoveMode,
            onAddTap: onAddTap,
            onOpenFile: onOpenFile,
            onRename: onRename,
            onDelete: onDelete,
            onMove: onMove,
            onDownload: onDownload,
            onShareFile: onShareFile,
            onViewSharedUsersFile: onViewSharedUsersFile,
            onShareFolder: onShareFolder,
            onViewSharedUsersFolder: onViewSharedUsersFolder,
          );

    return RefreshIndicator(
      color: AppColor.primaryBlue,
      onRefresh: () async {
        if (bloc.state.isCreating || bloc.state.isFolderLoading) {
          return;
        }
        bloc.add(const StorageRefreshed());
        await bloc.stream.firstWhere((s) => !s.isFolderLoading);
      },
      child: content,
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uit_buddy_mobile/app/di/app_dependencies.dart';
import 'package:uit_buddy_mobile/core/theme/app_color.dart';
import 'package:uit_buddy_mobile/core/theme/app_text_style.dart';
import 'package:uit_buddy_mobile/features/storage/presentation/bloc/storage_bloc.dart';
import 'package:uit_buddy_mobile/features/storage/presentation/bloc/storage_event.dart';
import 'package:uit_buddy_mobile/features/storage/presentation/bloc/storage_state.dart';
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

          return PopScope(
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
                                ? '${state.documents?.items.length ?? 0} items'
                                : '${state.classes.length} items',
                            style: AppTextStyle.captionMedium.copyWith(
                              color: AppColor.secondaryText,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // ── Breadcrumb (folder mode only) ────────────────────────
                    if (isFolder && state.currentFolder != null)
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
                        child: Row(
                          children: [
                            GestureDetector(
                              onTap: () => context.read<StorageBloc>().add(
                                const StorageBackPressed(),
                              ),
                              child: Text(
                                'Storage',
                                style: AppTextStyle.captionMedium.copyWith(
                                  color: AppColor.primaryBlue,
                                ),
                              ),
                            ),
                            Text(
                              ' / ',
                              style: AppTextStyle.captionMedium.copyWith(
                                color: AppColor.secondaryText,
                              ),
                            ),
                            Expanded(
                              child: Text(
                                '${state.currentFolder!.classCode} - '
                                '${state.currentFolder!.course.courseName}',
                                style: AppTextStyle.captionMedium.copyWith(
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
                      child: _buildContent(context, state, isGrid, isFolder),
                    ),
                  ],
                ),
              ),
            ),
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
    if (!isFolder) {
      if (state.isClassesLoading) {
        return const Center(child: CircularProgressIndicator());
      }
      if (state.errorMessage != null && state.classes.isEmpty) {
        return Center(
          child: Text(state.errorMessage!, style: AppTextStyle.bodyMedium),
        );
      }
      if (state.classes.isEmpty) {
        return Center(
          child: Text(
            'No classes found.',
            style: AppTextStyle.bodyMedium.copyWith(
              color: AppColor.secondaryText,
            ),
          ),
        );
      }
      return isGrid ? _FolderGrid(state: state) : _FolderList(state: state);
    } else {
      if (state.isDocumentsLoading) {
        return const Center(child: CircularProgressIndicator());
      }
      if (state.errorMessage != null && state.documents == null) {
        return Center(
          child: Text(state.errorMessage!, style: AppTextStyle.bodyMedium),
        );
      }
      return isGrid ? _FileGrid(state: state) : _FileList(state: state);
    }
  }
}

// ── Folder grid ────────────────────────────────────────────────────────────────

class _FolderGrid extends StatelessWidget {
  const _FolderGrid({required this.state});

  final StorageState state;

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
      itemCount: state.classes.length,
      itemBuilder: (context, index) {
        final folder = state.classes[index];
        return StorageFolderWidget(
          folder: folder,
          isGrid: true,
          onTap: () => context.read<StorageBloc>().add(
            StorageFolderOpened(folder: folder),
          ),
        );
      },
    );
  }
}

// ── Folder list ────────────────────────────────────────────────────────────────

class _FolderList extends StatelessWidget {
  const _FolderList({required this.state});

  final StorageState state;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemCount: state.classes.length,
      separatorBuilder: (_, _) =>
          const Divider(height: 1, indent: 72, color: AppColor.dividerGrey),
      itemBuilder: (context, index) {
        final folder = state.classes[index];
        return StorageFolderWidget(
          folder: folder,
          isGrid: false,
          onTap: () => context.read<StorageBloc>().add(
            StorageFolderOpened(folder: folder),
          ),
        );
      },
    );
  }
}

// ── File grid ─────────────────────────────────────────────────────────────────

class _FileGrid extends StatelessWidget {
  const _FileGrid({required this.state});

  final StorageState state;

  @override
  Widget build(BuildContext context) {
    final files = state.documents?.items ?? [];
    return GridView.builder(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 1.0,
      ),
      itemCount: files.length + 1,
      itemBuilder: (context, index) {
        if (index == files.length) {
          return StorageAddFileButton(isGrid: true, onTap: () {});
        }
        return StorageFileWidget(
          file: files[index],
          isGrid: true,
          onChangeAccess: () {},
          onShare: () {},
          onDelete: () {},
        );
      },
    );
  }
}

// ── File list ─────────────────────────────────────────────────────────────────

class _FileList extends StatelessWidget {
  const _FileList({required this.state});

  final StorageState state;

  @override
  Widget build(BuildContext context) {
    final files = state.documents?.items ?? [];
    return ListView.separated(
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemCount: files.length + 1,
      separatorBuilder: (_, _) =>
          const Divider(height: 1, indent: 72, color: AppColor.dividerGrey),
      itemBuilder: (context, index) {
        if (index == files.length) {
          return StorageAddFileButton(isGrid: false, onTap: () {});
        }
        return StorageFileWidget(
          file: files[index],
          isGrid: false,
          onChangeAccess: () {},
          onShare: () {},
          onDelete: () {},
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

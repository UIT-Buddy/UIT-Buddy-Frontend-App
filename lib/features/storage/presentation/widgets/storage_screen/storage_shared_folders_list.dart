import 'package:flutter/material.dart';
import 'package:uit_buddy_mobile/core/theme/app_text_style.dart';
import 'package:uit_buddy_mobile/features/storage/domain/entities/folder_entity.dart';
import 'package:uit_buddy_mobile/features/storage/presentation/widgets/storage_folder_widget.dart';

class StorageSharedFoldersList extends StatelessWidget {
  const StorageSharedFoldersList({
    super.key,
    required this.sharedFolders,
    required this.onFolderTap,
  });

  final List<FolderEntity> sharedFolders;
  final ValueChanged<FolderEntity> onFolderTap;

  @override
  Widget build(BuildContext context) {
    if (sharedFolders.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Text('Shared with you', style: AppTextStyle.h4),
        ),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 16),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 1.0,
          ),
          itemCount: sharedFolders.length,
          itemBuilder: (context, index) {
            final folder = sharedFolders[index];
            return StorageFolderWidget(
              subFolder: SubFolderEntity(
                id: folder.id,
                name: folder.name,
                itemCount: folder.files.length + folder.folders.length,
              ),
              isGrid: true,
              onTap: () => onFolderTap(folder),
              onShare: null,
              onViewSharedUsers: null,
            );
          },
        ),
        const SizedBox(height: 24),
      ],
    );
  }
}

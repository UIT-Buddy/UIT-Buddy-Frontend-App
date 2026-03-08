import 'package:flutter/material.dart';
import 'package:uit_buddy_mobile/core/theme/app_color.dart';
import 'package:uit_buddy_mobile/core/theme/app_text_style.dart';
import 'package:uit_buddy_mobile/features/storage/domain/entities/subject_class_entity.dart';

class StorageFolderWidget extends StatelessWidget {
  const StorageFolderWidget({
    super.key,
    required this.folder,
    required this.isGrid,
    required this.onTap,
  });

  final SubjectClassEntity folder;
  final bool isGrid;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return isGrid
        ? _GridCard(folder: folder, onTap: onTap)
        : _ListTile(folder: folder, onTap: onTap);
  }
}

class _GridCard extends StatelessWidget {
  const _GridCard({required this.folder, required this.onTap});

  final SubjectClassEntity folder;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
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
            Text(
              '${folder.classCode} - ${folder.course.courseName}',
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
  const _ListTile({required this.folder, required this.onTap});

  final SubjectClassEntity folder;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
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
        folder.classCode,
        style: AppTextStyle.bodySmall.copyWith(fontWeight: AppTextStyle.medium),
      ),
      subtitle: Text(
        folder.course.courseName,
        style: AppTextStyle.captionMedium,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      trailing: const Icon(Icons.chevron_right, color: AppColor.secondaryText),
    );
  }
}

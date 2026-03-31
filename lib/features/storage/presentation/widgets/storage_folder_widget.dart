import 'package:flutter/material.dart';
import 'package:uit_buddy_mobile/core/theme/app_color.dart';
import 'package:uit_buddy_mobile/core/theme/app_text_style.dart';
import 'package:uit_buddy_mobile/features/storage/domain/entities/folder_entity.dart';
import 'package:uit_buddy_mobile/features/storage/domain/entities/subject_class_entity.dart';

class StorageFolderWidget extends StatelessWidget {
  const StorageFolderWidget({
    super.key,
    this.classFolder,
    this.subFolder,
    required this.isGrid,
    required this.onTap,
  }) : assert(classFolder != null || subFolder != null);

  final SubjectClassEntity? classFolder;
  final SubFolderEntity? subFolder;
  final bool isGrid;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return isGrid
        ? _GridCard(
            classFolder: classFolder,
            subFolder: subFolder,
            onTap: onTap,
          )
        : _ListTile(
            classFolder: classFolder,
            subFolder: subFolder,
            onTap: onTap,
          );
  }
}

class _GridCard extends StatelessWidget {
  const _GridCard({this.classFolder, this.subFolder, required this.onTap});

  final SubjectClassEntity? classFolder;
  final SubFolderEntity? subFolder;
  final VoidCallback onTap;

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
  const _ListTile({this.classFolder, this.subFolder, required this.onTap});

  final SubjectClassEntity? classFolder;
  final SubFolderEntity? subFolder;
  final VoidCallback onTap;

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
    );
  }
}

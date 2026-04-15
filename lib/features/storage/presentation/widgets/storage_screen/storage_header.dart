import 'package:flutter/material.dart';
import 'package:uit_buddy_mobile/core/theme/app_color.dart';
import 'package:uit_buddy_mobile/core/theme/app_text_style.dart';
import 'package:uit_buddy_mobile/features/storage/presentation/widgets/storage_screen/storage_view_type_toggle.dart';

class StorageScreenHeader extends StatelessWidget {
  const StorageScreenHeader({
    super.key,
    required this.isGrid,
    required this.itemCount,
    required this.onToggleViewType,
  });

  final bool isGrid;
  final int itemCount;
  final VoidCallback onToggleViewType;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 16, 8),
      child: Row(
        children: [
          Text(
            'Storage',
            style: AppTextStyle.h1.copyWith(fontWeight: AppTextStyle.bold),
          ),
          const Spacer(),
          StorageViewTypeToggle(isGrid: isGrid, onToggle: onToggleViewType),
          const SizedBox(width: 12),
          Text(
            '$itemCount items',
            style: AppTextStyle.captionMedium.copyWith(
              color: AppColor.secondaryText,
            ),
          ),
        ],
      ),
    );
  }
}

class StorageFolderBreadcrumb extends StatelessWidget {
  const StorageFolderBreadcrumb({
    super.key,
    required this.path,
    required this.onBack,
  });

  final String path;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
      child: Row(
        children: [
          Expanded(
            child: Text(
              path,
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
            onTap: onBack,
            child: const Icon(
              Icons.arrow_back,
              color: AppColor.secondaryText,
              size: 20,
            ),
          ),
        ],
      ),
    );
  }
}

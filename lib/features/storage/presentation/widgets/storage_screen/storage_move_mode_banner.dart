import 'package:flutter/material.dart';
import 'package:uit_buddy_mobile/core/theme/app_color.dart';
import 'package:uit_buddy_mobile/core/theme/app_text_style.dart';

class StorageMoveModeBanner extends StatelessWidget {
  const StorageMoveModeBanner({
    super.key,
    required this.fileName,
    required this.canMoveHere,
    required this.onCancel,
    required this.onMoveHere,
  });

  final String fileName;
  final bool canMoveHere;
  final VoidCallback onCancel;
  final VoidCallback onMoveHere;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: AppColor.primaryBlue10,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColor.primaryBlue.withValues(alpha: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.drive_file_move_outline,
                color: AppColor.primaryBlue,
                size: 18,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Moving "$fileName"',
                  style: AppTextStyle.bodySmall.copyWith(
                    color: AppColor.primaryBlue,
                    fontWeight: AppTextStyle.bold,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              TextButton(onPressed: onCancel, child: const Text('Cancel')),
            ],
          ),
          Row(
            children: [
              Expanded(
                child: Text(
                  canMoveHere
                      ? 'Navigate as usual, then tap Move Here when this is the destination folder.'
                      : 'Open a different folder to enable moving.',
                  style: AppTextStyle.captionMedium.copyWith(
                    color: AppColor.secondaryText,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              ElevatedButton.icon(
                onPressed: canMoveHere ? onMoveHere : null,
                icon: const Icon(Icons.drive_file_move_rounded, size: 16),
                label: const Text('Move Here'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

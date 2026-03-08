import 'package:flutter/material.dart';
import 'package:uit_buddy_mobile/core/theme/app_color.dart';
import 'package:uit_buddy_mobile/core/theme/app_text_style.dart';

class StorageAddFileButton extends StatelessWidget {
  const StorageAddFileButton({
    super.key,
    required this.isGrid,
    this.onTap,
  });

  final bool isGrid;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return isGrid ? _GridAdd(onTap: onTap) : _ListAdd(onTap: onTap);
  }
}

class _GridAdd extends StatelessWidget {
  const _GridAdd({this.onTap});

  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: AppColor.dividerGrey,
            width: 1.5,
          ),
        ),
        child: Center(
          child: Icon(Icons.add, color: AppColor.tertiaryText, size: 32),
        ),
      ),
    );
  }
}

class _ListAdd extends StatelessWidget {
  const _ListAdd({this.onTap});

  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColor.dividerGrey, width: 1.5),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.add, color: AppColor.secondaryText, size: 20),
            const SizedBox(width: 8),
            Text(
              'Add file',
              style: AppTextStyle.bodySmall
                  .copyWith(color: AppColor.secondaryText),
            ),
          ],
        ),
      ),
    );
  }
}

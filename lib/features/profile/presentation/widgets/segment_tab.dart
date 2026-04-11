import 'package:flutter/material.dart';
import 'package:uit_buddy_mobile/core/theme/app_color.dart';
import 'package:uit_buddy_mobile/core/theme/app_text_style.dart';

class SegmentTab extends StatelessWidget {
  const SegmentTab({
    super.key,
    required this.label,
    required this.description,
    required this.onTap,
    required this.labelColor,
  });

  final String label;
  final String description;
  final VoidCallback onTap;
  final Color labelColor;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: AppTextStyle.bodyLarge.copyWith(
                fontWeight: AppTextStyle.bold,
                color: labelColor,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              description,
              style: AppTextStyle.bodyMedium.copyWith(
                color: AppColor.secondaryText,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

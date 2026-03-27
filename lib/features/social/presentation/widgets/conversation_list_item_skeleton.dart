import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:uit_buddy_mobile/core/theme/app_color.dart';

class ConversationListItemSkeleton extends StatelessWidget {
  const ConversationListItemSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: AppColor.dividerGrey,
      highlightColor: AppColor.veryLightGrey,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: Row(
          children: [
            _box(width: 52, height: 52, borderRadius: 26),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(child: _box(width: double.infinity, height: 13)),
                      const SizedBox(width: 8),
                      _box(width: 36, height: 11),
                    ],
                  ),
                  const SizedBox(height: 8),
                  _box(width: double.infinity, height: 11),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _box({
    required double width,
    required double height,
    double borderRadius = 6,
  }) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(borderRadius),
      ),
    );
  }
}

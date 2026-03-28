import 'package:flutter/material.dart';
import 'package:uit_buddy_mobile/core/theme/app_color.dart';

class PostCardSkeleton extends StatelessWidget {
  final bool showImage;

  const PostCardSkeleton({super.key, this.showImage = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(color: AppColor.dividerGrey, width: 6),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Author skeleton
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: AppColor.veryLightGrey,
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 120,
                        height: 12,
                        color: AppColor.veryLightGrey,
                      ),
                      const SizedBox(height: 8),
                      Container(
                        width: 80,
                        height: 10,
                        color: AppColor.veryLightGrey,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // Content skeleton
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 12,
                  color: AppColor.veryLightGrey,
                ),
                const SizedBox(height: 8),
                Container(
                  height: 12,
                  width: double.infinity,
                  color: AppColor.veryLightGrey,
                ),
                const SizedBox(height: 8),
                Container(
                  height: 12,
                  width: 200,
                  color: AppColor.veryLightGrey,
                ),
              ],
            ),
          ),
          if (showImage) ...[
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Container(
                height: 200,
                width: double.infinity,
                color: AppColor.veryLightGrey,
              ),
            ),
          ],
          const SizedBox(height: 12),
        ],
      ),
    );
  }
}

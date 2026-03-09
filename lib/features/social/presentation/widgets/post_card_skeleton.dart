import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:uit_buddy_mobile/core/theme/app_color.dart';

class PostCardSkeleton extends StatelessWidget {
  /// Whether to show the image placeholder block in this skeleton card.
  final bool showImage;

  const PostCardSkeleton({super.key, this.showImage = false});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: AppColor.dividerGrey,
      highlightColor: AppColor.veryLightGrey,
      child: Container(
        decoration: const BoxDecoration(
          border: Border(
            bottom: BorderSide(color: AppColor.dividerGrey, width: 6),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Author row skeleton
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
              child: Row(
                children: [
                  // Avatar circle
                  _box(width: 42, height: 42, borderRadius: 21),
                  const SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _box(width: 130, height: 13),
                      const SizedBox(height: 6),
                      _box(width: 80, height: 11),
                    ],
                  ),
                  const Spacer(),
                  _box(width: 24, height: 24, borderRadius: 4),
                ],
              ),
            ),

            // Content lines skeleton
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _box(width: double.infinity, height: 13),
                  const SizedBox(height: 6),
                  _box(width: double.infinity, height: 13),
                  const SizedBox(height: 6),
                  _box(width: 200, height: 13),
                ],
              ),
            ),

            // Optional image placeholder
            if (showImage) ...[
              const SizedBox(height: 8),
              AspectRatio(
                aspectRatio: 16 / 10,
                child: _box(
                  width: double.infinity,
                  height: double.infinity,
                  borderRadius: 0,
                ),
              ),
            ],

            // Stats row skeleton
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
              child: Row(
                children: [
                  _box(width: 60, height: 12),
                  const SizedBox(width: 16),
                  _box(width: 60, height: 12),
                  const SizedBox(width: 16),
                  _box(width: 60, height: 12),
                ],
              ),
            ),

            // Action bar skeleton
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _box(width: 72, height: 28, borderRadius: 6),
                  _box(width: 72, height: 28, borderRadius: 6),
                  _box(width: 72, height: 28, borderRadius: 6),
                ],
              ),
            ),

            const SizedBox(height: 4),
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

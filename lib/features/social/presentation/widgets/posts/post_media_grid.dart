import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uit_buddy_mobile/features/social/presentation/widgets/posts/post_video_preview_tile.dart';

const _videoExtensions = {'mp4', 'mov', 'avi', 'mkv', 'webm', 'm4v'};

bool isVideoFile(XFile file) =>
    _videoExtensions.contains(file.name.split('.').last.toLowerCase());

class PostMediaGrid extends StatelessWidget {
  const PostMediaGrid({super.key, required this.files, required this.onRemove});

  final List<XFile> files;
  final void Function(int index) onRemove;

  @override
  Widget build(BuildContext context) {
    final count = files.length;

    if (count == 1) {
      return _tile(files[0], 0, height: 240, radius: 12);
    }

    if (count == 2) {
      return Row(
        children: [
          Expanded(child: _tile(files[0], 0, height: 180)),
          const SizedBox(width: 4),
          Expanded(child: _tile(files[1], 1, height: 180)),
        ],
      );
    }

    if (count == 3) {
      return Row(
        children: [
          Expanded(child: _tile(files[0], 0, height: 220)),
          const SizedBox(width: 4),
          Expanded(
            child: Column(
              children: [
                _tile(files[1], 1, height: 108),
                const SizedBox(height: 4),
                _tile(files[2], 2, height: 108),
              ],
            ),
          ),
        ],
      );
    }

    // 4+ → horizontal scroll
    return SizedBox(
      height: 140,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: count,
        separatorBuilder: (context, index) => const SizedBox(width: 6),
        itemBuilder: (_, i) =>
            SizedBox(width: 140, child: _tile(files[i], i, height: 140)),
      ),
    );
  }

  Widget _tile(
    XFile file,
    int index, {
    required double height,
    double radius = 10,
  }) {
    if (isVideoFile(file)) {
      return PostVideoPreviewTile(
        key: ValueKey(file.path),
        file: file,
        height: height,
        radius: radius,
        onRemove: () => onRemove(index),
      );
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(radius),
      child: Stack(
        children: [
          Image.file(
            File(file.path),
            width: double.infinity,
            height: height,
            fit: BoxFit.cover,
          ),
          _RemoveButton(onTap: () => onRemove(index)),
        ],
      ),
    );
  }
}

class _RemoveButton extends StatelessWidget {
  const _RemoveButton({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 6,
      right: 6,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          width: 24,
          height: 24,
          decoration: BoxDecoration(
            color: Colors.black54,
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Icon(Icons.close, color: Colors.white, size: 15),
        ),
      ),
    );
  }
}

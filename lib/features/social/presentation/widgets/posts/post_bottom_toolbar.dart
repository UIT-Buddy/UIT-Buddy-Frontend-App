import 'package:flutter/material.dart';
import 'package:uit_buddy_mobile/core/theme/app_color.dart';
import 'package:uit_buddy_mobile/core/theme/app_text_style.dart';

class PostBottomToolbar extends StatelessWidget {
  const PostBottomToolbar({
    super.key,
    required this.onPickGallery,
    required this.onPickCamera,
    required this.onPickFile,
    required this.charCount,
    required this.showCharCount,
  });

  final VoidCallback onPickGallery;
  final VoidCallback onPickCamera;
  final VoidCallback onPickFile;
  final int charCount;
  final bool showCharCount;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColor.pureWhite,
        border: Border(top: BorderSide(color: AppColor.dividerGrey, width: 1)),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
          child: Row(
            children: [
              _ToolbarButton(
                icon: Icons.image_outlined,
                color: AppColor.successGreen,
                onTap: onPickGallery,
              ),
              _ToolbarButton(
                icon: Icons.camera_alt_outlined,
                color: AppColor.primaryBlue,
                onTap: onPickCamera,
              ),
              _ToolbarButton(
                icon: Icons.attach_file_outlined,
                color: AppColor.starYellow,
                onTap: onPickFile,
              ),
              const Spacer(),
              AnimatedOpacity(
                duration: const Duration(milliseconds: 200),
                opacity: showCharCount ? 1.0 : 0.0,
                child: Text('$charCount', style: AppTextStyle.captionMedium),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ToolbarButton extends StatelessWidget {
  const _ToolbarButton({
    required this.icon,
    required this.color,
    required this.onTap,
  });

  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onTap,
      icon: Icon(icon, color: color, size: 24),
      splashRadius: 20,
      padding: const EdgeInsets.all(10),
      constraints: const BoxConstraints(minWidth: 44, minHeight: 44),
    );
  }
}

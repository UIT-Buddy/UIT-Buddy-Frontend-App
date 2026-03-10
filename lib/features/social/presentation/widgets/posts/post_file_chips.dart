import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:uit_buddy_mobile/core/theme/app_color.dart';
import 'package:uit_buddy_mobile/core/theme/app_text_style.dart';

class PostFileChips extends StatelessWidget {
  const PostFileChips({
    super.key,
    required this.files,
    required this.onRemove,
  });

  final List<PlatformFile> files;
  final void Function(int index) onRemove;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: List.generate(
        files.length,
        (i) => _FileChip(file: files[i], onRemove: () => onRemove(i)),
      ),
    );
  }
}

class _FileChip extends StatelessWidget {
  const _FileChip({required this.file, required this.onRemove});

  final PlatformFile file;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
      decoration: BoxDecoration(
        color: AppColor.veryLightGrey,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColor.dividerGrey),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(_iconFor(file.extension), size: 16, color: AppColor.primaryBlue),
          const SizedBox(width: 6),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 150),
            child: Text(
              file.name,
              style: AppTextStyle.captionMedium.copyWith(
                color: AppColor.primaryText,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(width: 4),
          Text(
            _sizeLabel(file.size),
            style: AppTextStyle.captionMedium.copyWith(
              color: AppColor.secondaryText,
            ),
          ),
          const SizedBox(width: 8),
          GestureDetector(
            onTap: onRemove,
            child: const Icon(
              Icons.close,
              size: 14,
              color: AppColor.secondaryText,
            ),
          ),
        ],
      ),
    );
  }

  static String _sizeLabel(int? bytes) {
    if (bytes == null) return '';
    if (bytes < 1024) return '${bytes}B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)}KB';
    return '${(bytes / (1024 * 1024)).toStringAsFixed(1)}MB';
  }

  static IconData _iconFor(String? ext) {
    switch (ext?.toLowerCase()) {
      case 'pdf':
        return Icons.picture_as_pdf_outlined;
      case 'doc':
      case 'docx':
        return Icons.description_outlined;
      case 'xls':
      case 'xlsx':
        return Icons.table_chart_outlined;
      case 'ppt':
      case 'pptx':
        return Icons.slideshow_outlined;
      case 'zip':
      case 'rar':
      case '7z':
        return Icons.folder_zip_outlined;
      default:
        return Icons.insert_drive_file_outlined;
    }
  }
}

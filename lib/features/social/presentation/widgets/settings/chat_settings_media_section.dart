import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:uit_buddy_mobile/core/theme/app_color.dart';
import 'package:uit_buddy_mobile/core/theme/app_text_style.dart';
import 'package:uit_buddy_mobile/features/social/domain/entities/shared_media_entity.dart';
import 'package:uit_buddy_mobile/features/social/presentation/bloc/chat_settings/chat_settings_state.dart';
import 'package:uit_buddy_mobile/features/social/presentation/constants/chat_setting_text.dart';
import 'package:uit_buddy_mobile/features/social/presentation/widgets/settings/settings_section.dart';

class ChatSettingsMediaSection extends StatelessWidget {
  final List<SharedMediaEntity> sharedMedia;
  final List<SharedMediaEntity> sharedFiles;
  final ChatSettingsMediaTab selectedTab;
  final ValueChanged<int> onTabChanged;

  const ChatSettingsMediaSection({
    super.key,
    required this.sharedMedia,
    required this.sharedFiles,
    required this.selectedTab,
    required this.onTabChanged,
  });

  @override
  Widget build(BuildContext context) {
    final isMedia = selectedTab == ChatSettingsMediaTab.media;
    final activeItems = isMedia ? sharedMedia : sharedFiles;

    return SettingsSection(
      title: ChatSettingText.mediaSectionTitle,
      children: [
        _MediaTabBar(
          selectedIndex: isMedia ? 0 : 1,
          onTabChanged: onTabChanged,
        ),
        const SizedBox(height: 2),
        if (isMedia)
          _MediaGrid(items: sharedMedia)
        else
          _FileList(items: sharedFiles),
        if (activeItems.isNotEmpty) ...[
          const Divider(height: 1, color: AppColor.dividerGrey),
          _SeeAllButton(
            label: isMedia
                ? ChatSettingText.seeAllPhotos
                : ChatSettingText.seeAllFiles,
            onTap: () {},
          ),
        ],
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Tab bar
// ---------------------------------------------------------------------------

class _MediaTabBar extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onTabChanged;

  static const double _padding = 3.0;
  static const double _itemHeight = 36.0;

  const _MediaTabBar({required this.selectedIndex, required this.onTabChanged});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final itemWidth = (constraints.maxWidth - _padding * 2) / 2;
          return Container(
            height: _itemHeight + _padding * 2,
            decoration: BoxDecoration(
              color: AppColor.veryLightGrey,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Stack(
              children: [
                AnimatedPositioned(
                  duration: const Duration(milliseconds: 280),
                  curve: Curves.easeInOutCubic,
                  left: _padding + selectedIndex * itemWidth,
                  top: _padding,
                  width: itemWidth,
                  height: _itemHeight,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: AppColor.primaryBlue,
                      borderRadius: BorderRadius.circular(18),
                      boxShadow: [
                        BoxShadow(
                          color: AppColor.primaryBlue.withValues(alpha: 0.35),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(_padding),
                  child: Row(
                    children: [
                      _Tab(
                        label: ChatSettingText.mediaTab,
                        isSelected: selectedIndex == 0,
                        width: itemWidth,
                        height: _itemHeight,
                        onTap: () => onTabChanged(0),
                      ),
                      _Tab(
                        label: ChatSettingText.filesTab,
                        isSelected: selectedIndex == 1,
                        width: itemWidth,
                        height: _itemHeight,
                        onTap: () => onTabChanged(1),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _Tab extends StatelessWidget {
  final String label;
  final bool isSelected;
  final double width;
  final double height;
  final VoidCallback onTap;

  const _Tab({
    required this.label,
    required this.isSelected,
    required this.width,
    required this.height,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        width: width,
        height: height,
        child: Center(
          child: AnimatedDefaultTextStyle(
            duration: const Duration(milliseconds: 220),
            curve: Curves.easeInOut,
            style: AppTextStyle.bodySmall.copyWith(
              color: isSelected ? AppColor.pureWhite : AppColor.secondaryText,
              fontWeight: isSelected
                  ? AppTextStyle.medium
                  : AppTextStyle.regular,
            ),
            child: Text(label),
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Media grid
// ---------------------------------------------------------------------------

class _MediaGrid extends StatelessWidget {
  final List<SharedMediaEntity> items;

  const _MediaGrid({required this.items});

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 24),
        child: Center(
          child: Text(
            ChatSettingText.noPhotosShared,
            style: AppTextStyle.bodySmall.copyWith(
              color: AppColor.secondaryText,
            ),
          ),
        ),
      );
    }
    final preview = items.take(9).toList();
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(2, 0, 2, 2),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 2,
        mainAxisSpacing: 2,
      ),
      itemCount: preview.length,
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () {},
          child: CachedNetworkImage(
            imageUrl: preview[index].url,
            fit: BoxFit.cover,
            placeholder: (context, url) =>
                Container(color: AppColor.veryLightGrey),
            errorWidget: (context, url, error) =>
                Container(color: AppColor.veryLightGrey),
          ),
        );
      },
    );
  }
}

// ---------------------------------------------------------------------------
// File list
// ---------------------------------------------------------------------------

class _FileList extends StatelessWidget {
  final List<SharedMediaEntity> items;

  const _FileList({required this.items});

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 24),
        child: Center(
          child: Text(
            ChatSettingText.noFilesShared,
            style: AppTextStyle.bodySmall.copyWith(
              color: AppColor.secondaryText,
            ),
          ),
        ),
      );
    }
    return Column(
      children: items.asMap().entries.map((entry) {
        final i = entry.key;
        final file = entry.value;
        return Column(
          children: [
            _FileRow(file: file),
            if (i < items.length - 1)
              const Padding(
                padding: EdgeInsets.only(left: 64),
                child: Divider(height: 1, color: AppColor.dividerGrey),
              ),
          ],
        );
      }).toList(),
    );
  }
}

class _FileRow extends StatelessWidget {
  final SharedMediaEntity file;

  const _FileRow({required this.file});

  @override
  Widget build(BuildContext context) {
    final ext = (file.fileName ?? '').split('.').last.toUpperCase();
    final extColor = _extColor(ext);

    return InkWell(
      onTap: () {},
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: extColor.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(10),
              ),
              alignment: Alignment.center,
              child: Text(
                ext.length > 4 ? ext.substring(0, 4) : ext,
                style: AppTextStyle.captionSmall.copyWith(
                  color: extColor,
                  fontWeight: AppTextStyle.bold,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    file.fileName ?? '',
                    style: AppTextStyle.bodySmall,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '${file.fileSize ?? ''} • ${_formatDate(file.sharedAt)}',
                    style: AppTextStyle.captionMedium,
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.download_outlined,
              color: AppColor.primaryBlue,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }

  Color _extColor(String ext) {
    switch (ext) {
      case 'PDF':
        return AppColor.alertRed;
      case 'DOCX':
      case 'DOC':
        return AppColor.primaryBlue;
      case 'PPTX':
      case 'PPT':
        return AppColor.warningOrange;
      case 'XLSX':
      case 'XLS':
        return AppColor.successGreen;
      default:
        return AppColor.secondaryText;
    }
  }

  String _formatDate(DateTime dt) => '${dt.day}/${dt.month}/${dt.year}';
}

// ---------------------------------------------------------------------------
// See all button
// ---------------------------------------------------------------------------

class _SeeAllButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const _SeeAllButton({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 14),
        child: Center(
          child: Text(
            label,
            style: AppTextStyle.bodySmall.copyWith(
              color: AppColor.primaryBlue,
              fontWeight: AppTextStyle.medium,
            ),
          ),
        ),
      ),
    );
  }
}

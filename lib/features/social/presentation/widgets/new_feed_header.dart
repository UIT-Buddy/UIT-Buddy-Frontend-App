import 'package:flutter/material.dart';
import 'package:uit_buddy_mobile/core/theme/app_color.dart';
import 'package:uit_buddy_mobile/core/theme/app_text_style.dart';
import 'package:uit_buddy_mobile/features/social/presentation/constants/social_text.dart';

class NewFeedHeader extends StatelessWidget {
  final int selectedTabIndex;
  final ValueChanged<int> onTabChanged;
  final VoidCallback onSearchTap;

  const NewFeedHeader({
    super.key,
    required this.selectedTabIndex,
    required this.onTabChanged,
    required this.onSearchTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 10),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: AppColor.veryLightGrey,
              borderRadius: BorderRadius.circular(14),
            ),
            child: IconButton(
              onPressed: onSearchTap,
              icon: const Icon(
                Icons.search_rounded,
                color: AppColor.primaryText,
                size: 22,
              ),
              tooltip: SocialText.searchTitle,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Align(
              alignment: Alignment.centerRight,
              child: _SlidingTabToggle(
                tabs: [SocialText.feedTab, SocialText.messageTab],
                selectedIndex: selectedTabIndex,
                onTabChanged: onTabChanged,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SlidingTabToggle extends StatelessWidget {
  final List<String> tabs;
  final int selectedIndex;
  final ValueChanged<int> onTabChanged;

  // Fixed dimensions for consistent sliding calculation
  static const double _itemWidth = 84.0;
  static const double _itemHeight = 36.0;
  static const double _padding = 3.0;

  const _SlidingTabToggle({
    required this.tabs,
    required this.selectedIndex,
    required this.onTabChanged,
  });

  @override
  Widget build(BuildContext context) {
    final double totalWidth = _itemWidth * tabs.length + _padding * 2;

    return Container(
      width: totalWidth,
      height: _itemHeight + _padding * 2,
      decoration: BoxDecoration(
        color: AppColor.veryLightGrey,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Stack(
        children: [
          // Sliding pill background
          AnimatedPositioned(
            duration: const Duration(milliseconds: 280),
            curve: Curves.easeInOutCubic,
            left: _padding + selectedIndex * _itemWidth,
            top: _padding,
            width: _itemWidth,
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
          // Tab labels
          Padding(
            padding: const EdgeInsets.all(_padding),
            child: Row(
              children: List.generate(tabs.length, (i) {
                final isSelected = selectedIndex == i;
                return GestureDetector(
                  onTap: () => onTabChanged(i),
                  behavior: HitTestBehavior.opaque,
                  child: SizedBox(
                    width: _itemWidth,
                    height: _itemHeight,
                    child: Center(
                      child: AnimatedDefaultTextStyle(
                        duration: const Duration(milliseconds: 220),
                        curve: Curves.easeInOut,
                        style: AppTextStyle.bodySmall.copyWith(
                          color: isSelected
                              ? AppColor.pureWhite
                              : AppColor.secondaryText,
                          fontWeight: isSelected
                              ? AppTextStyle.medium
                              : AppTextStyle.regular,
                        ),
                        child: Text(tabs[i]),
                      ),
                    ),
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}

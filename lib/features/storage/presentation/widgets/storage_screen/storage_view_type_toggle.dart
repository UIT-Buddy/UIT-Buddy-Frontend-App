import 'package:flutter/material.dart';
import 'package:uit_buddy_mobile/core/theme/app_color.dart';

class StorageViewTypeToggle extends StatelessWidget {
  const StorageViewTypeToggle({
    super.key,
    required this.isGrid,
    required this.onToggle,
  });

  final bool isGrid;
  final VoidCallback onToggle;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColor.dividerGrey,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _ToggleButton(
            icon: Icons.grid_view_rounded,
            selected: isGrid,
            onTap: isGrid ? null : onToggle,
          ),
          _ToggleButton(
            icon: Icons.format_list_bulleted_rounded,
            selected: !isGrid,
            onTap: !isGrid ? null : onToggle,
          ),
        ],
      ),
    );
  }
}

class _ToggleButton extends StatelessWidget {
  const _ToggleButton({required this.icon, required this.selected, this.onTap});

  final IconData icon;
  final bool selected;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          color: selected ? AppColor.pureWhite : Colors.transparent,
          borderRadius: BorderRadius.circular(6),
          boxShadow: selected
              ? const [BoxShadow(color: AppColor.shadowColor, blurRadius: 4)]
              : null,
        ),
        child: Icon(
          icon,
          size: 18,
          color: selected ? AppColor.primaryBlue : AppColor.secondaryText,
        ),
      ),
    );
  }
}

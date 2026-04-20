import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:uit_buddy_mobile/app/router/route_name.dart';
import 'package:uit_buddy_mobile/core/theme/app_color.dart';
import 'package:uit_buddy_mobile/core/theme/app_text_style.dart';
import 'package:uit_buddy_mobile/features/home/presentation/constants/home_text.dart';

class SelectionOptionWidget extends StatelessWidget {
  const SelectionOptionWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _SelectionItem(
          icon: Icons.language_rounded,
          label: HomeText.selectionWebsites,
          subBgColor: AppColor.primaryBlue10,
          iconColor: AppColor.primaryBlue,
          onTap: () => context.push(RouteName.website),
        ),
        _SelectionItem(
          icon: Icons.sticky_note_2_outlined,
          label: HomeText.selectionNote,
          subBgColor: AppColor.warningOrangeLight,
          iconColor: AppColor.warningOrange,
          onTap: () => context.push(RouteName.note),
        ),
        _SelectionItem(
          icon: Icons.wb_sunny_rounded,
          label: HomeText.selectionWeather,
          subBgColor: AppColor.successGreen10,
          iconColor: AppColor.successGreen,
          onTap: () => context.push(RouteName.weather),
        ),
        _SelectionItem(
          icon: Icons.grid_view_rounded,
          label: HomeText.selectionMore,
          subBgColor: AppColor.veryLightGrey,
          iconColor: AppColor.secondaryText,
        ),
      ],
    );
  }
}

class _SelectionItem extends StatelessWidget {
  const _SelectionItem({
    required this.icon,
    required this.label,
    required this.subBgColor,
    required this.iconColor,
    this.onTap,
  });

  final IconData icon;
  final String label;
  final Color subBgColor;
  final Color iconColor;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: subBgColor,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColor.dividerGrey, width: 1),
            ),
            child: Center(child: Icon(icon, color: iconColor, size: 28)),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: AppTextStyle.captionMedium.copyWith(
              color: AppColor.primaryText,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

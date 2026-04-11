import 'package:flutter/material.dart';
import 'package:uit_buddy_mobile/core/theme/app_color.dart';
import 'package:uit_buddy_mobile/core/theme/app_text_style.dart';

class FriendsSearchBar extends StatelessWidget {
  const FriendsSearchBar({
    super.key,
    required this.controller,
    required this.hintText,
    required this.showClear,
  });

  final TextEditingController controller;
  final String hintText;
  final bool showClear;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14),
      child: Container(
        height: 42,
        decoration: BoxDecoration(
          color: AppColor.dividerGrey,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            const SizedBox(width: 10),
            const Icon(Icons.search, color: AppColor.secondaryText, size: 22),
            const SizedBox(width: 8),
            Expanded(
              child: TextField(
                controller: controller,
                style: AppTextStyle.bodySmall,
                decoration: InputDecoration(
                  fillColor: AppColor.dividerGrey,
                  isDense: true,
                  border: InputBorder.none,
                  hintText: hintText,
                  hintStyle: AppTextStyle.bodySmall.copyWith(
                    color: AppColor.secondaryText,
                  ),
                ),
              ),
            ),
            if (showClear)
              IconButton(
                icon: const Icon(Icons.close, size: 18),
                color: AppColor.secondaryText,
                onPressed: controller.clear,
              )
            else
              const Padding(
                padding: EdgeInsets.only(right: 12),
                child: Icon(Icons.tune, color: AppColor.secondaryText),
              ),
          ],
        ),
      ),
    );
  }
}

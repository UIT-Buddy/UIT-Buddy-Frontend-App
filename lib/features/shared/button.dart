import 'package:flutter/material.dart';
import 'package:uit_buddy_mobile/core/theme/app_color.dart';
import 'package:uit_buddy_mobile/core/theme/app_text_style.dart';

class Button extends StatelessWidget {
  final String? text;
  final IconData? iconLeft;
  final IconData? iconRight;
  final VoidCallback onPressed;

  const Button({
    super.key,
    this.text,
    this.iconLeft,
    this.iconRight,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColor.primaryBlue,
        foregroundColor: AppColor.pureWhite,
        padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 10),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        minimumSize: const Size(double.infinity, 0),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (iconLeft != null) ...[
            Icon(iconLeft, size: 20, color: AppColor.pureWhite),
            if (text != null) const SizedBox(width: 8),
          ],
          if (text != null)
            Text(
              text!,
              style: AppTextStyle.bodyLarge.copyWith(
                fontWeight: AppTextStyle.bold,
                color: AppColor.pureWhite,
              ),
            ),
          if (iconRight != null) ...[
            if (text != null) const SizedBox(width: 8),
            Icon(iconRight, size: 20, color: AppColor.pureWhite),
          ],
        ],
      ),
    );
  }
}

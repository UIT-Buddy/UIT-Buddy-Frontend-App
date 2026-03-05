import 'package:flutter/material.dart';
import 'package:uit_buddy_mobile/core/theme/app_color.dart';
import 'package:uit_buddy_mobile/core/theme/app_text_style.dart';

class Button extends StatelessWidget {
  final String? text;
  final IconData? iconLeft;
  final IconData? iconRight;
  final VoidCallback onPressed;
  final bool isLoading;

  const Button({
    super.key,
    this.text,
    this.iconLeft,
    this.iconRight,
    required this.onPressed,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: isLoading ? null : onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColor.primaryBlue,
        foregroundColor: AppColor.pureWhite,
        disabledBackgroundColor: AppColor.primaryBlue,
        padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 10),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        minimumSize: const Size(double.infinity, 0),
      ),
      child: isLoading
          ? const SizedBox(
              height: 20,
              width: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: AppColor.pureWhite,
              ),
            )
          : Row(
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

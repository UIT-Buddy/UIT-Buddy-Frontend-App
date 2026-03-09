import 'package:flutter/material.dart';
import 'package:uit_buddy_mobile/core/theme/app_color.dart';
import 'package:uit_buddy_mobile/core/theme/app_text_style.dart';

class Button extends StatefulWidget {
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
  State<Button> createState() => _ButtonState();
}

class _ButtonState extends State<Button> with SingleTickerProviderStateMixin {
  late final AnimationController _pressController;
  late final Animation<double> _scaleAnim;

  @override
  void initState() {
    super.initState();
    _pressController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 90),
      reverseDuration: const Duration(milliseconds: 180),
      lowerBound: 0.0,
      upperBound: 1.0,
    );
    _scaleAnim = Tween<double>(begin: 1.0, end: 0.96).animate(
      CurvedAnimation(parent: _pressController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _pressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _pressController.forward(),
      onTapUp: (_) => _pressController.reverse(),
      onTapCancel: () => _pressController.reverse(),
      onTap: widget.isLoading ? null : widget.onPressed,
      child: ScaleTransition(
        scale: _scaleAnim,
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            gradient: widget.isLoading ? null : AppColor.primaryGradient,
            color: widget.isLoading ? AppColor.primaryBlue : null,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: AppColor.primaryBlue.withValues(alpha: 0.35),
                blurRadius: 14,
                spreadRadius: 0,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          padding: const EdgeInsets.symmetric(vertical: 15),
          child: widget.isLoading
              ? const Center(
                  child: SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: AppColor.pureWhite,
                    ),
                  ),
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (widget.iconLeft != null) ...[
                      Icon(
                        widget.iconLeft,
                        size: 20,
                        color: AppColor.pureWhite,
                      ),
                      if (widget.text != null) const SizedBox(width: 8),
                    ],
                    if (widget.text != null)
                      Text(
                        widget.text!,
                        style: AppTextStyle.bodyLarge.copyWith(
                          fontWeight: AppTextStyle.bold,
                          color: AppColor.pureWhite,
                          letterSpacing: 0.3,
                        ),
                      ),
                    if (widget.iconRight != null) ...[
                      if (widget.text != null) const SizedBox(width: 8),
                      Icon(
                        widget.iconRight,
                        size: 20,
                        color: AppColor.pureWhite,
                      ),
                    ],
                  ],
                ),
        ),
      ),
    );
  }
}

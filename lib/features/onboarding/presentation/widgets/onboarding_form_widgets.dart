import 'package:flutter/material.dart';
import 'package:uit_buddy_mobile/core/theme/app_color.dart';
import 'package:uit_buddy_mobile/core/theme/app_text_style.dart';

/// Gradient header banner used on Sign-In / OTP / Reset-Password screens.
class OnboardingHeader extends StatelessWidget {
  const OnboardingHeader({
    super.key,
    required this.onBack,
    required this.title,
    required this.subtitle,
  });

  final VoidCallback onBack;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(
        20,
        MediaQuery.of(context).padding.top + 16,
        20,
        28,
      ),
      decoration: const BoxDecoration(
        gradient: AppColor.primaryGradient,
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(32)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: onBack,
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.2),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.arrow_back,
                color: AppColor.pureWhite,
                size: 20,
              ),
            ),
          ),
          const SizedBox(height: 20),

          Text(
            title,
            style: AppTextStyle.h1.copyWith(
              color: AppColor.pureWhite,
              fontWeight: AppTextStyle.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: AppTextStyle.bodyLarge.copyWith(
              color: AppColor.pureWhite.withValues(alpha: 0.85),
            ),
          ),
        ],
      ),
    );
  }
}

/// White card that wraps form fields with a subtle shadow.
class OnboardingFormCard extends StatelessWidget {
  const OnboardingFormCard({super.key, required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColor.pureWhite,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: child,
    );
  }
}

/// Bold field label above an input.
class FieldLabel extends StatelessWidget {
  const FieldLabel(this.text, {super.key});
  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: AppTextStyle.bodySmall.copyWith(
        color: AppColor.primaryText,
        fontWeight: FontWeight.w600,
      ),
    );
  }
}

/// "Don't have an account? Sign up" footer row.
class OnboardingFooter extends StatelessWidget {
  const OnboardingFooter({
    super.key,
    required this.prompt,
    required this.actionText,
    required this.onTap,
  });

  final String prompt;
  final String actionText;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          prompt,
          style: AppTextStyle.bodySmall.copyWith(color: AppColor.secondaryText),
        ),
        TextButton(
          onPressed: onTap,
          style: TextButton.styleFrom(
            padding: EdgeInsets.zero,
            minimumSize: Size.zero,
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
          child: Text(
            actionText,
            style: AppTextStyle.bodySmall.copyWith(
              color: AppColor.primaryBlue,
              fontWeight: AppTextStyle.bold,
            ),
          ),
        ),
      ],
    );
  }
}

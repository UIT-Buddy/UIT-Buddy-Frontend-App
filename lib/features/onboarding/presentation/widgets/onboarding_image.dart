import 'package:flutter/material.dart';
import 'package:uit_buddy_mobile/core/theme/app_color.dart';

class OnboardingImage extends StatelessWidget {
  static const String onboardingImage = 'assets/images/onboarding_image.png';
  static const String hidingRectangle = 'assets/images/hiding_rectangle.png';

  const OnboardingImage({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: Stack(
        fit: StackFit.expand,
        children: [
          // Main onboarding image
          Image.asset(onboardingImage, fit: BoxFit.cover),

          // Gradient fade at bottom to blend into the card
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            height: 160,
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    AppColor.veryLightGrey.withValues(alpha: 0.6),
                    AppColor.veryLightGrey,
                  ],
                ),
              ),
            ),
          ),

          // Legacy hiding rectangle (kept for exact pixel match if needed)
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Image.asset(
              hidingRectangle,
              fit: BoxFit.cover,
              width: double.infinity,
            ),
          ),
        ],
      ),
    );
  }
}

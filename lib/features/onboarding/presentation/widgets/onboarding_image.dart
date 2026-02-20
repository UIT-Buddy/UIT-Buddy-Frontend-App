import 'package:flutter/material.dart';
import 'package:uit_buddy_mobile/core/theme/app_color.dart';

class OnboardingImage extends StatelessWidget {
  static const String onboardingImage = 'assets/images/onboarding_image.png';
  static const String hidingRectangle = 'assets/images/hiding_rectangle.png';

  const OnboardingImage({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColor.pureWhite,
      child: Stack(
        children: [
          // Main onboarding image
          Image.asset(
            onboardingImage,
            fit: BoxFit.cover,
            width: double.infinity,
          ),
          // Hiding rectangle overlaid at the bottom
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

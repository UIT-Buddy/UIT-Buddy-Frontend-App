import 'package:flutter/material.dart';
import 'package:uit_buddy_mobile/app/router/extensions/router_extension.dart';
import 'package:uit_buddy_mobile/app/router/route_name.dart';
import 'package:uit_buddy_mobile/core/theme/app_color.dart';
import 'package:uit_buddy_mobile/core/theme/app_text_style.dart';
import 'package:uit_buddy_mobile/features/onboarding/presentation/constants/onboarding_text.dart';
import 'package:uit_buddy_mobile/features/onboarding/presentation/widgets/onboarding_image.dart';
import 'package:uit_buddy_mobile/features/shared/button.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.pureWhite,
      body: Column(
        children: [
          const Expanded(flex: 3, child: OnboardingImage()),

          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 24, right: 10),
                    child: Column(
                      children: [
                        RichText(
                          textAlign: TextAlign.left,
                          text: TextSpan(
                            style: AppTextStyle.nextClassTitle.copyWith(
                              fontWeight: AppTextStyle.bold,
                            ),
                            children: [
                              TextSpan(
                                text: OnboardingText.title1,
                                style: TextStyle(color: AppColor.primaryText),
                              ),
                              TextSpan(
                                text: OnboardingText.title2Left,
                                style: TextStyle(color: AppColor.primaryBlue),
                              ),
                              TextSpan(
                                text: OnboardingText.title2Right,
                                style: TextStyle(color: AppColor.primaryText),
                              ),
                            ],
                          ),
                        ),

                        Text(
                          OnboardingText.subTitle,
                          style: AppTextStyle.bodyLarge.copyWith(
                            color: AppColor.secondaryText,
                          ),
                          textAlign: TextAlign.left,
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 30),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Button(
                      text: OnboardingText.buttonScreen1,
                      iconRight: Icons.arrow_forward_ios_outlined,
                      onPressed: () {
                        context.goTo(RouteName.signIn);
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

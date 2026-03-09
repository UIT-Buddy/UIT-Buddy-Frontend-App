import 'package:flutter/material.dart';
import 'package:uit_buddy_mobile/app/router/extensions/router_extension.dart';
import 'package:uit_buddy_mobile/app/router/route_name.dart';
import 'package:uit_buddy_mobile/core/theme/app_color.dart';
import 'package:uit_buddy_mobile/core/theme/app_text_style.dart';
import 'package:uit_buddy_mobile/features/onboarding/presentation/constants/onboarding_text.dart';
import 'package:uit_buddy_mobile/features/onboarding/presentation/widgets/onboarding_image.dart';
import 'package:uit_buddy_mobile/features/shared/button.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _fadeAnim;
  late final Animation<Offset> _slideAnim;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );
    _fadeAnim = CurvedAnimation(parent: _controller, curve: Curves.easeOut);
    _slideAnim = Tween<Offset>(
      begin: const Offset(0, 0.18),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: AppColor.veryLightGrey,
      body: Stack(
        children: [
          // Full-height image background
          SizedBox(
            height: screenHeight * 0.65,
            width: double.infinity,
            child: const OnboardingImage(),
          ),

          // Bottom sheet card
          Align(
            alignment: Alignment.bottomCenter,
            child: FadeTransition(
              opacity: _fadeAnim,
              child: SlideTransition(
                position: _slideAnim,
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.fromLTRB(28, 32, 28, 40),
                  decoration: BoxDecoration(
                    color: AppColor.pureWhite,
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(32),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.10),
                        blurRadius: 30,
                        offset: const Offset(0, -6),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Pill indicator
                      Center(
                        child: Container(
                          width: 40,
                          height: 4,
                          margin: const EdgeInsets.only(bottom: 24),
                          decoration: BoxDecoration(
                            color: AppColor.dividerGrey,
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                      ),

                      RichText(
                        text: TextSpan(
                          style: AppTextStyle.nextClassTitle.copyWith(
                            fontWeight: AppTextStyle.bold,
                            height: 1.15,
                          ),
                          children: [
                            TextSpan(
                              text: OnboardingText.title1,
                              style: const TextStyle(
                                color: AppColor.primaryText,
                              ),
                            ),
                            TextSpan(
                              text: OnboardingText.title2Left,
                              style: const TextStyle(
                                color: AppColor.primaryBlue,
                              ),
                            ),
                            TextSpan(
                              text: OnboardingText.title2Right,
                              style: const TextStyle(
                                color: AppColor.primaryText,
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 12),

                      Text(
                        OnboardingText.subTitle,
                        style: AppTextStyle.bodyLarge.copyWith(
                          color: AppColor.secondaryText,
                        ),
                      ),

                      const SizedBox(height: 32),

                      Button(
                        text: OnboardingText.buttonScreen1,
                        iconRight: Icons.arrow_forward_ios_outlined,
                        onPressed: () => context.goTo(RouteName.signIn),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

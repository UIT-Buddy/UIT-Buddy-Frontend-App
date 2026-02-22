import 'package:flutter/material.dart';
import 'package:uit_buddy_mobile/app/router/extensions/router_extension.dart';
import 'package:uit_buddy_mobile/app/router/route_name.dart';
import 'package:uit_buddy_mobile/core/theme/app_color.dart';
import 'package:uit_buddy_mobile/core/theme/app_text_style.dart';
import 'package:uit_buddy_mobile/features/onboarding/presentation/constants/onboarding_text.dart';
import 'package:uit_buddy_mobile/features/shared/button.dart';
import 'package:uit_buddy_mobile/features/shared/input_text.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final TextEditingController _studentIdController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _rememberMe = false;

  @override
  void dispose() {
    _studentIdController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.pureWhite,
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 50, horizontal: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: AppColor.veryLightGrey,
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    icon: const Icon(
                      Icons.arrow_back,
                      size: 20,
                      color: AppColor.primaryText,
                    ),
                    onPressed: () {
                      context.goBack(RouteName.welcome);
                    },
                    padding: EdgeInsets.zero,
                  ),
                ),

                const SizedBox(height: 30),

                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      OnboardingText.signInTitle,
                      style: AppTextStyle.h1.copyWith(
                        fontWeight: AppTextStyle.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      OnboardingText.signInSubtitle,
                      style: AppTextStyle.bodyLarge.copyWith(
                        color: AppColor.secondaryText,
                      ),
                    ),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 50),

            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  OnboardingText.studentIdLabel,
                  style: AppTextStyle.bodySmall.copyWith(
                    color: AppColor.secondaryText,
                  ),
                ),
                const SizedBox(height: 6),
                InputText(
                  controller: _studentIdController,
                  leftIcon: Icons.person_outline,
                ),
                const SizedBox(height: 16),
                Text(
                  OnboardingText.passwordLabel,
                  style: AppTextStyle.bodySmall.copyWith(
                    color: AppColor.secondaryText,
                  ),
                ),
                const SizedBox(height: 6),
                InputText(
                  controller: _passwordController,
                  isPassword: true,
                  leftIcon: Icons.lock_outline,
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        SizedBox(
                          width: 24,
                          height: 24,
                          child: Checkbox(
                            value: _rememberMe,
                            onChanged: (value) {
                              setState(() {
                                _rememberMe = value ?? false;
                              });
                            },
                            activeColor: AppColor.primaryBlue,
                            side: const BorderSide(
                              color: AppColor.secondaryText,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          OnboardingText.rememberMe,
                          style: AppTextStyle.bodySmall.copyWith(
                            color: AppColor.secondaryText,
                          ),
                        ),
                      ],
                    ),
                    TextButton(
                      onPressed: () {
                        context.goTo(RouteName.otp);
                      },
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.zero,
                        minimumSize: Size.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      child: Text(
                        OnboardingText.forgotPassword,
                        style: AppTextStyle.bodySmall.copyWith(
                          color: AppColor.primaryBlue,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Button(
                  text: OnboardingText.signInButton,
                  onPressed: () {
                    // TODO: Implement sign in logic
                    context.goTo(RouteName.home);
                  },
                ),
              ],
            ),
            const Spacer(),
            Center(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    OnboardingText.signUpPrompt,
                    style: AppTextStyle.bodySmall.copyWith(
                      color: AppColor.secondaryText,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      context.goTo(RouteName.signUpToken);
                    },
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.zero,
                      minimumSize: Size.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    child: Text(
                      OnboardingText.signUpButtonText,
                      style: AppTextStyle.bodySmall.copyWith(
                        color: AppColor.primaryBlue,
                        fontWeight: AppTextStyle.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

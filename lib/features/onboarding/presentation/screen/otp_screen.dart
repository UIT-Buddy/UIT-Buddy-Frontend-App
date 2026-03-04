import 'package:flutter/material.dart';
import 'package:uit_buddy_mobile/app/router/extensions/router_extension.dart';
import 'package:uit_buddy_mobile/app/router/route_name.dart';
import 'package:uit_buddy_mobile/core/theme/app_color.dart';
import 'package:uit_buddy_mobile/core/theme/app_text_style.dart';
import 'package:uit_buddy_mobile/features/onboarding/presentation/constants/onboarding_text.dart';
import 'package:uit_buddy_mobile/features/onboarding/presentation/widgets/otp_input_field.dart';
import 'package:uit_buddy_mobile/features/shared/button.dart';

class OtpScreen extends StatelessWidget {
  const OtpScreen({super.key});

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
                      context.goBack(RouteName.signIn);
                    },
                    padding: EdgeInsets.zero,
                  ),
                ),

                const SizedBox(height: 30),

                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      OnboardingText.otpTitle,
                      style: AppTextStyle.h1.copyWith(
                        fontWeight: AppTextStyle.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      OnboardingText.otpSubtitle,
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
                  OnboardingText.otpInputLabel,
                  style: AppTextStyle.bodySmall.copyWith(
                    color: AppColor.secondaryText,
                  ),
                ),
                const SizedBox(height: 6),
                OtpInputField(),

                const SizedBox(height: 16),
                Button(
                  text: OnboardingText.otpButton,
                  onPressed: () {
                    // TODO: Implement OTP verification logic
                    context.goTo(RouteName.resetPassword);
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
                    OnboardingText.signInPromt,
                    style: AppTextStyle.bodySmall.copyWith(
                      color: AppColor.secondaryText,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      context.goBack(RouteName.signIn);
                    },
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.zero,
                      minimumSize: Size.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    child: Text(
                      OnboardingText.signInButtonText,
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

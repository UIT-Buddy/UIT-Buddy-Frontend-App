import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uit_buddy_mobile/app/router/extensions/router_extension.dart';
import 'package:uit_buddy_mobile/app/router/route_name.dart';
import 'package:uit_buddy_mobile/core/theme/app_color.dart';
import 'package:uit_buddy_mobile/core/theme/app_text_style.dart';
import 'package:uit_buddy_mobile/features/onboarding/presentation/blocs/sign_up_token/sign_up_token_bloc.dart';
import 'package:uit_buddy_mobile/features/onboarding/presentation/blocs/sign_up_token/sign_up_token_event.dart';
import 'package:uit_buddy_mobile/features/onboarding/presentation/blocs/sign_up_token/sign_up_token_state.dart';
import 'package:uit_buddy_mobile/features/onboarding/presentation/constants/onboarding_text.dart';
import 'package:uit_buddy_mobile/features/shared/button.dart';
import 'package:uit_buddy_mobile/features/shared/input_text.dart';

class SignUpTokenScreen extends StatefulWidget {
  const SignUpTokenScreen({super.key});

  @override
  State<SignUpTokenScreen> createState() => _SignUpTokenScreenState();
}

class _SignUpTokenScreenState extends State<SignUpTokenScreen> {
  final TextEditingController _tokenController = TextEditingController();

  @override
  void dispose() {
    _tokenController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SignUpTokenBloc, SignUpTokenState>(
      listener: (context, state) {
        if (state.status == SignUpTokenStatus.success && state.entity != null) {
          context.goTo(
            RouteName.buildSignUpInfoPath(
              state.entity!.studentId,
              state.entity!.studentName,
              state.entity!.signupToken,
            ),
          );
        } else if (state.status == SignUpTokenStatus.failure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.errorMessage ?? 'Verification failed'),
              backgroundColor: AppColor.alertRed,
            ),
          );
        }
      },
      builder: (context, state) {
        final isLoading = state.status == SignUpTokenStatus.loading;
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
                          OnboardingText.signUpTitle,
                          style: AppTextStyle.h1.copyWith(
                            fontWeight: AppTextStyle.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          OnboardingText.signUpSubtitle1,
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
                      OnboardingText.moodleTokenLabel,
                      style: AppTextStyle.bodySmall.copyWith(
                        color: AppColor.secondaryText,
                      ),
                    ),
                    const SizedBox(height: 6),
                    InputText(
                      controller: _tokenController,
                      isPassword: true,
                      leftIcon: Icons.key_outlined,
                    ),
                    const SizedBox(height: 16),
                    Button(
                      text: OnboardingText.signUpVerifyButton,
                      isLoading: isLoading,
                      onPressed: () {
                        context.read<SignUpTokenBloc>().add(
                          SignUpTokenVerifyPressed(
                            wstoken: _tokenController.text.trim(),
                          ),
                        );
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
      },
    );
  }
}

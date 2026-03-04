import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uit_buddy_mobile/app/router/extensions/router_extension.dart';
import 'package:uit_buddy_mobile/app/router/route_name.dart';
import 'package:uit_buddy_mobile/core/theme/app_color.dart';
import 'package:uit_buddy_mobile/core/theme/app_text_style.dart';
import 'package:uit_buddy_mobile/features/onboarding/presentation/blocs/sign_up_info/sign_up_info_bloc.dart';
import 'package:uit_buddy_mobile/features/onboarding/presentation/blocs/sign_up_info/sign_up_info_event.dart';
import 'package:uit_buddy_mobile/features/onboarding/presentation/blocs/sign_up_info/sign_up_info_state.dart';
import 'package:uit_buddy_mobile/features/onboarding/presentation/constants/onboarding_text.dart';
import 'package:uit_buddy_mobile/features/shared/button.dart';
import 'package:uit_buddy_mobile/features/shared/input_text.dart';

class SignUpInfoScreen extends StatefulWidget {
  const SignUpInfoScreen({
    super.key,
    required this.studentId,
    required this.studentFullName,
    required this.signupToken,
  });

  final String studentId;
  final String studentFullName;
  final String signupToken;

  @override
  State<SignUpInfoScreen> createState() => _SignUpInfoScreenState();
}

class _SignUpInfoScreenState extends State<SignUpInfoScreen> {
  late final TextEditingController _studentIdController = TextEditingController(
    text: widget.studentId,
  );
  late final TextEditingController _fullNameController = TextEditingController(
    text: widget.studentFullName,
  );
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  @override
  void dispose() {
    _studentIdController.dispose();
    _fullNameController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SignUpInfoBloc, SignUpInfoState>(
      listener: (context, state) {
        if (state.status == SignUpInfoStatus.success) {
          context.goTo(RouteName.signIn);
        } else if (state.status == SignUpInfoStatus.failure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.errorMessage ?? 'Sign up failed'),
              backgroundColor: AppColor.alertRed,
            ),
          );
        }
      },
      builder: (context, state) {
        final isLoading = state.status == SignUpInfoStatus.loading;
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
                          context.goBack(RouteName.signUpToken);
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
                          OnboardingText.signUpSubtitle2,
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
                      OnboardingText.signUpStudentIdLabel,
                      style: AppTextStyle.bodySmall.copyWith(
                        color: AppColor.secondaryText,
                      ),
                    ),
                    const SizedBox(height: 6),
                    InputText(
                      controller: _studentIdController,
                      leftIcon: Icons.person_outline,
                      readOnly: true,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      OnboardingText.signUpFullNameLabel,
                      style: AppTextStyle.bodySmall.copyWith(
                        color: AppColor.secondaryText,
                      ),
                    ),
                    const SizedBox(height: 6),
                    InputText(
                      controller: _fullNameController,
                      leftIcon: Icons.badge_outlined,
                      readOnly: true,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      OnboardingText.signUpPasswordLabel,
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
                    Text(
                      OnboardingText.signUpConfirmPasswordLabel,
                      style: AppTextStyle.bodySmall.copyWith(
                        color: AppColor.secondaryText,
                      ),
                    ),
                    const SizedBox(height: 6),
                    InputText(
                      controller: _confirmPasswordController,
                      isPassword: true,
                      leftIcon: Icons.lock_outline,
                    ),
                    const SizedBox(height: 16),
                    Button(
                      text: OnboardingText.signUpButton,
                      isLoading: isLoading,
                      onPressed: () {
                        context.read<SignUpInfoBloc>().add(
                          SignUpInfoSubmitPressed(
                            signupToken: widget.signupToken,
                            mssv: widget.studentId,
                            password: _passwordController.text,
                            confirmPassword: _confirmPasswordController.text,
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

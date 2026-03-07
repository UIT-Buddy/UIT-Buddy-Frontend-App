import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uit_buddy_mobile/app/di/app_dependencies.dart';
import 'package:uit_buddy_mobile/app/router/extensions/router_extension.dart';
import 'package:uit_buddy_mobile/app/router/route_name.dart';
import 'package:uit_buddy_mobile/core/theme/app_color.dart';
import 'package:uit_buddy_mobile/core/theme/app_text_style.dart';
import 'package:uit_buddy_mobile/features/onboarding/presentation/blocs/otp/otp_bloc.dart';
import 'package:uit_buddy_mobile/features/onboarding/presentation/blocs/otp/otp_event.dart';
import 'package:uit_buddy_mobile/features/onboarding/presentation/blocs/otp/otp_state.dart';
import 'package:uit_buddy_mobile/features/onboarding/presentation/constants/onboarding_text.dart';
import 'package:uit_buddy_mobile/features/onboarding/presentation/widgets/otp_input_field.dart';
import 'package:uit_buddy_mobile/features/shared/button.dart';
import 'package:uit_buddy_mobile/features/shared/input_text.dart';

class OtpScreen extends StatelessWidget {
  const OtpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => serviceLocator<OtpBloc>(),
      child: const _OtpScreenBody(),
    );
  }
}

class _OtpScreenBody extends StatefulWidget {
  const _OtpScreenBody();

  @override
  State<_OtpScreenBody> createState() => _OtpScreenBodyState();
}

class _OtpScreenBodyState extends State<_OtpScreenBody> {
  final TextEditingController _mssvController = TextEditingController();
  String _otpCode = '';

  @override
  void dispose() {
    _mssvController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<OtpBloc, OtpState>(
      listener: (context, state) {
        if (state.status == OtpStatus.failure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.errorMessage ?? 'Failed to send OTP'),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      builder: (context, state) {
        final isSent = state.status == OtpStatus.sent;
        final isLoading = state.status == OtpStatus.loading;

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
                          isSent
                              ? OnboardingText.otpTitle
                              : OnboardingText.forgotPasswordTitle,
                          style: AppTextStyle.h1.copyWith(
                            fontWeight: AppTextStyle.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          isSent
                              ? OnboardingText.otpSubtitle
                              : OnboardingText.forgotPasswordSubtitle,
                          style: AppTextStyle.bodyLarge.copyWith(
                            color: AppColor.secondaryText,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),

                const SizedBox(height: 50),

                if (!isSent) ...[
                  Text(
                    OnboardingText.mssvInputLabel,
                    style: AppTextStyle.bodySmall.copyWith(
                      color: AppColor.secondaryText,
                    ),
                  ),
                  const SizedBox(height: 6),
                  InputText(
                    controller: _mssvController,
                    leftIcon: Icons.badge_outlined,
                  ),
                  const SizedBox(height: 16),
                  Button(
                    text: OnboardingText.sendOtpButton,
                    isLoading: isLoading,
                    onPressed: () {
                      final mssv = _mssvController.text.trim();
                      if (mssv.isNotEmpty) {
                        context.read<OtpBloc>().add(
                          OtpSendRequested(mssv: mssv),
                        );
                      }
                    },
                  ),
                ] else ...[
                  Text(
                    OnboardingText.otpInputLabel,
                    style: AppTextStyle.bodySmall.copyWith(
                      color: AppColor.secondaryText,
                    ),
                  ),
                  const SizedBox(height: 6),
                  OtpInputField(onChanged: (value) => _otpCode = value),
                  const SizedBox(height: 16),
                  Button(
                    text: OnboardingText.otpButton,
                    onPressed: () {
                      if (_otpCode.length == 6) {
                        context.goTo(
                          RouteName.buildResetPasswordPath(
                            state.mssv,
                            _otpCode,
                          ),
                        );
                      }
                    },
                  ),
                ],

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

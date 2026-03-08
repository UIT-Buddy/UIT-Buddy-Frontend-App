import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uit_buddy_mobile/app/di/app_dependencies.dart';
import 'package:uit_buddy_mobile/app/router/extensions/router_extension.dart';
import 'package:uit_buddy_mobile/app/router/route_name.dart';
import 'package:uit_buddy_mobile/core/theme/app_color.dart';
import 'package:uit_buddy_mobile/features/onboarding/presentation/blocs/reset_password/reset_password_bloc.dart';
import 'package:uit_buddy_mobile/features/onboarding/presentation/blocs/reset_password/reset_password_event.dart';
import 'package:uit_buddy_mobile/features/onboarding/presentation/blocs/reset_password/reset_password_state.dart';
import 'package:uit_buddy_mobile/features/onboarding/presentation/constants/onboarding_text.dart';
import 'package:uit_buddy_mobile/features/onboarding/presentation/widgets/onboarding_form_widgets.dart';
import 'package:uit_buddy_mobile/features/shared/button.dart';
import 'package:uit_buddy_mobile/features/shared/input_text.dart';

class ResetPasswordScreen extends StatelessWidget {
  const ResetPasswordScreen({
    super.key,
    required this.mssv,
    required this.otpCode,
  });

  final String mssv;
  final String otpCode;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => serviceLocator<ResetPasswordBloc>(),
      child: _ResetPasswordScreenBody(mssv: mssv, otpCode: otpCode),
    );
  }
}

class _ResetPasswordScreenBody extends StatefulWidget {
  const _ResetPasswordScreenBody({required this.mssv, required this.otpCode});

  final String mssv;
  final String otpCode;

  @override
  State<_ResetPasswordScreenBody> createState() =>
      _ResetPasswordScreenBodyState();
}

class _ResetPasswordScreenBodyState extends State<_ResetPasswordScreenBody>
    with SingleTickerProviderStateMixin {
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  late final AnimationController _animController;
  late final Animation<double> _fadeAnim;
  late final Animation<Offset> _slideAnim;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _fadeAnim = CurvedAnimation(parent: _animController, curve: Curves.easeOut);
    _slideAnim = Tween<Offset>(begin: const Offset(0, 0.12), end: Offset.zero)
        .animate(
          CurvedAnimation(parent: _animController, curve: Curves.easeOutCubic),
        );
    _animController.forward();
  }

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ResetPasswordBloc, ResetPasswordState>(
      listener: (context, state) {
        if (state.status == ResetPasswordStatus.success) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text(
                'Password reset successfully. Please sign in.',
              ),
              backgroundColor: AppColor.successGreen,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          );
          context.goTo(RouteName.signIn);
        } else if (state.status == ResetPasswordStatus.failure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.errorMessage ?? 'Failed to reset password'),
              backgroundColor: AppColor.alertRed,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          );
        }
      },
      builder: (context, state) {
        final isLoading = state.status == ResetPasswordStatus.loading;

        return Scaffold(
          backgroundColor: AppColor.veryLightGrey,
          body: Column(
            children: [
              OnboardingHeader(
                onBack: () => context.goBack(RouteName.otp),
                title: OnboardingText.resetPasswordTitle,
                subtitle: OnboardingText.resetPasswordSubtitle,
              ),
              Expanded(
                child: FadeTransition(
                  opacity: _fadeAnim,
                  child: SlideTransition(
                    position: _slideAnim,
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.fromLTRB(20, 24, 20, 24),
                      child: OnboardingFormCard(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const FieldLabel('New password'),
                            const SizedBox(height: 6),
                            InputText(
                              controller: _passwordController,
                              isPassword: true,
                              leftIcon: Icons.lock_outline,
                            ),
                            const SizedBox(height: 20),
                            const FieldLabel('Confirm password'),
                            const SizedBox(height: 6),
                            InputText(
                              controller: _confirmPasswordController,
                              isPassword: true,
                              leftIcon: Icons.lock_outline,
                            ),
                            const SizedBox(height: 24),
                            Button(
                              text: OnboardingText.resetPasswordButton,
                              isLoading: isLoading,
                              onPressed: () {
                                context.read<ResetPasswordBloc>().add(
                                  ResetPasswordSubmitted(
                                    mssv: widget.mssv,
                                    otpCode: widget.otpCode,
                                    newPassword: _passwordController.text,
                                    confirmPassword:
                                        _confirmPasswordController.text,
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 28),
                child: OnboardingFooter(
                  prompt: OnboardingText.signInPromt,
                  actionText: OnboardingText.signInButtonText,
                  onTap: () => context.goBack(RouteName.signIn),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

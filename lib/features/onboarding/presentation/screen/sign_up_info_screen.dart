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
import 'package:uit_buddy_mobile/features/onboarding/presentation/widgets/onboarding_form_widgets.dart';
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

class _SignUpInfoScreenState extends State<SignUpInfoScreen>
    with SingleTickerProviderStateMixin {
  late final TextEditingController _studentIdController = TextEditingController(
    text: widget.studentId,
  );
  late final TextEditingController _fullNameController = TextEditingController(
    text: widget.studentFullName,
  );
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
    _studentIdController.dispose();
    _fullNameController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _animController.dispose();
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
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          );
        }
      },
      builder: (context, state) {
        final isLoading = state.status == SignUpInfoStatus.loading;
        return Scaffold(
          backgroundColor: AppColor.veryLightGrey,
          body: Column(
            children: [
              OnboardingHeader(
                onBack: () => context.goBack(RouteName.signUpToken),
                title: OnboardingText.signUpTitle,
                subtitle: OnboardingText.signUpSubtitle2,
              ),
              Expanded(
                child: FadeTransition(
                  opacity: _fadeAnim,
                  child: SlideTransition(
                    position: _slideAnim,
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.fromLTRB(20, 24, 20, 24),
                      child: Column(
                        children: [
                          // Verified student info card
                          _VerifiedStudentCard(
                            studentId: widget.studentId,
                            fullName: widget.studentFullName,
                          ),
                          const SizedBox(height: 16),
                          // Password form card
                          OnboardingFormCard(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const FieldLabel(
                                  OnboardingText.signUpPasswordLabel,
                                ),
                                const SizedBox(height: 6),
                                InputText(
                                  controller: _passwordController,
                                  isPassword: true,
                                  leftIcon: Icons.lock_outline,
                                ),
                                const SizedBox(height: 20),
                                const FieldLabel(
                                  OnboardingText.signUpConfirmPasswordLabel,
                                ),
                                const SizedBox(height: 6),
                                InputText(
                                  controller: _confirmPasswordController,
                                  isPassword: true,
                                  leftIcon: Icons.lock_outline,
                                ),
                                const SizedBox(height: 24),
                                Button(
                                  text: OnboardingText.signUpButton,
                                  isLoading: isLoading,
                                  onPressed: () {
                                    context.read<SignUpInfoBloc>().add(
                                      SignUpInfoSubmitPressed(
                                        signupToken: widget.signupToken,
                                        mssv: widget.studentId,
                                        password: _passwordController.text,
                                        confirmPassword:
                                            _confirmPasswordController.text,
                                      ),
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
                        ],
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

/// Read-only card showing the verified student details from the token step.
class _VerifiedStudentCard extends StatelessWidget {
  const _VerifiedStudentCard({required this.studentId, required this.fullName});

  final String studentId;
  final String fullName;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: AppColor.successGreen10,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColor.successGreen.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppColor.successGreen,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.verified_user_outlined,
              color: AppColor.pureWhite,
              size: 20,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  fullName,
                  style: AppTextStyle.bodySmall.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppColor.primaryText,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  studentId,
                  style: AppTextStyle.captionSmall.copyWith(
                    color: AppColor.secondaryText,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: AppColor.successGreen,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              'Verified',
              style: AppTextStyle.captionSmall.copyWith(
                color: AppColor.pureWhite,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

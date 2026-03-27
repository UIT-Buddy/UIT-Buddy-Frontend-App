import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uit_buddy_mobile/app/di/app_dependencies.dart';
import 'package:uit_buddy_mobile/app/router/extensions/router_extension.dart';
import 'package:uit_buddy_mobile/app/router/route_name.dart';
import 'package:uit_buddy_mobile/core/theme/app_color.dart';
import 'package:uit_buddy_mobile/core/theme/app_text_style.dart';
import 'package:uit_buddy_mobile/features/onboarding/presentation/blocs/sign_in/sign_in_bloc.dart';
import 'package:uit_buddy_mobile/features/onboarding/presentation/blocs/sign_in/sign_in_event.dart';
import 'package:uit_buddy_mobile/features/onboarding/presentation/blocs/sign_in/sign_in_state.dart';
import 'package:uit_buddy_mobile/features/onboarding/presentation/constants/onboarding_text.dart';
import 'package:uit_buddy_mobile/features/onboarding/presentation/widgets/onboarding_form_widgets.dart';
import 'package:uit_buddy_mobile/features/session/presentation/bloc/session_bloc.dart';
import 'package:uit_buddy_mobile/features/session/presentation/bloc/session_event.dart';
import 'package:uit_buddy_mobile/features/shared/button.dart';
import 'package:uit_buddy_mobile/features/shared/input_text.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen>
    with SingleTickerProviderStateMixin {
  final TextEditingController _studentIdController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _rememberMe = false;

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
    _passwordController.dispose();
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => serviceLocator<SignInBloc>(),
      child: BlocConsumer<SignInBloc, SignInState>(
        listener: (context, state) {
          if (state.status == SignInStatus.success) {
            context.goTo(RouteName.home);
          } else if (state.status == SignInStatus.failure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.errorMessage ?? 'Sign in failed'),
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
          final isLoading = state.status == SignInStatus.loading;
          return Scaffold(
            backgroundColor: AppColor.veryLightGrey,
            body: Column(
              children: [
                OnboardingHeader(
                  onBack: () => context.goBack(RouteName.welcome),
                  title: OnboardingText.signInTitle,
                  subtitle: OnboardingText.signInSubtitle,
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
                              const FieldLabel('Student ID'),
                              const SizedBox(height: 6),
                              InputText(
                                controller: _studentIdController,
                                leftIcon: Icons.person_outline,
                              ),
                              const SizedBox(height: 20),
                              const FieldLabel('Password'),
                              const SizedBox(height: 6),
                              InputText(
                                controller: _passwordController,
                                isPassword: true,
                                leftIcon: Icons.lock_outline,
                              ),
                              const SizedBox(height: 16),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      SizedBox(
                                        width: 22,
                                        height: 22,
                                        child: Checkbox(
                                          value: _rememberMe,
                                          onChanged: (v) => setState(
                                            () => _rememberMe = v ?? false,
                                          ),
                                          activeColor: AppColor.primaryBlue,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              4,
                                            ),
                                          ),
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
                                    onPressed: () =>
                                        context.goTo(RouteName.otp),
                                    style: TextButton.styleFrom(
                                      padding: EdgeInsets.zero,
                                      minimumSize: Size.zero,
                                      tapTargetSize:
                                          MaterialTapTargetSize.shrinkWrap,
                                    ),
                                    child: Text(
                                      OnboardingText.forgotPassword,
                                      style: AppTextStyle.bodySmall.copyWith(
                                        color: AppColor.primaryBlue,
                                        fontWeight: AppTextStyle.medium,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 24),
                              Button(
                                text: OnboardingText.signInButton,
                                isLoading: isLoading,
                                onPressed: () {
                                  context.read<SignInBloc>().add(
                                    SignInPressed(
                                      mssv: _studentIdController.text.trim(),
                                      password: _passwordController.text,
                                      rememberMe: _rememberMe,
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
                    prompt: OnboardingText.signUpPrompt,
                    actionText: OnboardingText.signUpButtonText,
                    onTap: () => context.goTo(RouteName.signUpToken),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

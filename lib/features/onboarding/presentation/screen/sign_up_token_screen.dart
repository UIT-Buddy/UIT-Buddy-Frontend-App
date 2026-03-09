import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uit_buddy_mobile/app/router/extensions/router_extension.dart';
import 'package:uit_buddy_mobile/app/router/route_name.dart';
import 'package:uit_buddy_mobile/core/theme/app_color.dart';
import 'package:uit_buddy_mobile/features/onboarding/presentation/blocs/sign_up_token/sign_up_token_bloc.dart';
import 'package:uit_buddy_mobile/features/onboarding/presentation/blocs/sign_up_token/sign_up_token_event.dart';
import 'package:uit_buddy_mobile/features/onboarding/presentation/blocs/sign_up_token/sign_up_token_state.dart';
import 'package:uit_buddy_mobile/features/onboarding/presentation/constants/onboarding_text.dart';
import 'package:uit_buddy_mobile/features/onboarding/presentation/widgets/onboarding_form_widgets.dart';
import 'package:uit_buddy_mobile/features/shared/button.dart';
import 'package:uit_buddy_mobile/features/shared/input_text.dart';

class SignUpTokenScreen extends StatefulWidget {
  const SignUpTokenScreen({super.key});

  @override
  State<SignUpTokenScreen> createState() => _SignUpTokenScreenState();
}

class _SignUpTokenScreenState extends State<SignUpTokenScreen>
    with SingleTickerProviderStateMixin {
  final TextEditingController _tokenController = TextEditingController();

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
    _tokenController.dispose();
    _animController.dispose();
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
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          );
        }
      },
      builder: (context, state) {
        final isLoading = state.status == SignUpTokenStatus.loading;
        return Scaffold(
          backgroundColor: AppColor.veryLightGrey,
          body: Column(
            children: [
              OnboardingHeader(
                onBack: () => context.goBack(RouteName.signIn),
                title: OnboardingText.signUpTitle,
                subtitle: OnboardingText.signUpSubtitle1,
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
                            const FieldLabel(OnboardingText.moodleTokenLabel),
                            const SizedBox(height: 6),
                            InputText(
                              controller: _tokenController,
                              isPassword: true,
                              leftIcon: Icons.key_outlined,
                            ),
                            const SizedBox(height: 24),
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

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uit_buddy_mobile/app/di/app_dependencies.dart';
import 'package:uit_buddy_mobile/app/router/extensions/router_extension.dart';
import 'package:uit_buddy_mobile/app/router/route_name.dart';
import 'package:uit_buddy_mobile/core/theme/app_color.dart';
import 'package:uit_buddy_mobile/features/onboarding/presentation/blocs/otp/otp_bloc.dart';
import 'package:uit_buddy_mobile/features/onboarding/presentation/blocs/otp/otp_event.dart';
import 'package:uit_buddy_mobile/features/onboarding/presentation/blocs/otp/otp_state.dart';
import 'package:uit_buddy_mobile/features/onboarding/presentation/constants/onboarding_text.dart';
import 'package:uit_buddy_mobile/features/onboarding/presentation/widgets/onboarding_form_widgets.dart';
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

class _OtpScreenBodyState extends State<_OtpScreenBody>
    with SingleTickerProviderStateMixin {
  final TextEditingController _mssvController = TextEditingController();
  String _otpCode = '';

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
    _mssvController.dispose();
    _animController.dispose();
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
        final isSent = state.status == OtpStatus.sent;
        final isLoading = state.status == OtpStatus.loading;

        return Scaffold(
          backgroundColor: AppColor.veryLightGrey,
          body: Column(
            children: [
              OnboardingHeader(
                onBack: () => context.goBack(RouteName.signIn),
                title: isSent
                    ? OnboardingText.otpTitle
                    : OnboardingText.forgotPasswordTitle,
                subtitle: isSent
                    ? OnboardingText.otpSubtitle
                    : OnboardingText.forgotPasswordSubtitle,
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
                            if (!isSent) ...[
                              const FieldLabel('Student ID (MSSV)'),
                              const SizedBox(height: 6),
                              InputText(
                                controller: _mssvController,
                                leftIcon: Icons.badge_outlined,
                              ),
                              const SizedBox(height: 24),
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
                              const FieldLabel('Enter OTP code'),
                              const SizedBox(height: 12),
                              OtpInputField(
                                onChanged: (value) => _otpCode = value,
                              ),
                              const SizedBox(height: 24),
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

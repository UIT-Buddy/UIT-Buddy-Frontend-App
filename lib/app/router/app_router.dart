import 'package:go_router/go_router.dart';
import 'package:uit_buddy_mobile/app/router/route_name.dart';
import 'package:uit_buddy_mobile/app/router/transitions/slide_transition.dart';
import 'package:uit_buddy_mobile/features/onboarding/presentation/screen/otp_screen.dart';
import 'package:uit_buddy_mobile/features/onboarding/presentation/screen/reset_password_screen.dart';
import 'package:uit_buddy_mobile/features/onboarding/presentation/screen/sign_in_screen.dart';
import 'package:uit_buddy_mobile/features/onboarding/presentation/screen/sign_up_info_screen.dart';
import 'package:uit_buddy_mobile/features/onboarding/presentation/screen/sign_up_token_screen.dart';
import 'package:uit_buddy_mobile/features/onboarding/presentation/screen/welcome_screen.dart';

final goRouter = GoRouter(
  initialLocation: RouteName.welcome,
  routes: [
    GoRoute(
      path: RouteName.welcome,
      pageBuilder: (context, state) => buildFlexibleSlideTransition(
        context: context,
        state: state,
        child: const WelcomeScreen(),
      ),
    ),
    GoRoute(
      path: RouteName.signIn,
      pageBuilder: (context, state) => buildFlexibleSlideTransition(
        context: context,
        state: state,
        child: const SignInScreen(),
      ),
    ),
    GoRoute(
      path: RouteName.signUpToken,
      pageBuilder: (context, state) => buildFlexibleSlideTransition(
        context: context,
        state: state,
        child: const SignUpTokenScreen(),
      ),
    ),
    GoRoute(
      path: RouteName.signUpInfo,
      pageBuilder: (context, state) => buildFlexibleSlideTransition(
        context: context,
        state: state,
        child: const SignUpInfoScreen(),
      ),
    ),
    GoRoute(
      path: RouteName.otp,
      pageBuilder: (context, state) => buildFlexibleSlideTransition(
        context: context,
        state: state,
        child: const OtpScreen(),
      ),
    ),
    GoRoute(
      path: RouteName.resetPassword,
      pageBuilder: (context, state) => buildFlexibleSlideTransition(
        context: context,
        state: state,
        child: const ResetPasswordScreen(),
      ),
    ),
  ],
);

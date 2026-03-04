import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:uit_buddy_mobile/app/di/app_dependencies.dart';
import 'package:uit_buddy_mobile/app/router/route_name.dart';
import 'package:uit_buddy_mobile/app/router/transitions/slide_transition.dart';
import 'package:uit_buddy_mobile/features/onboarding/presentation/blocs/sign_up_info/sign_up_info_bloc.dart';
import 'package:uit_buddy_mobile/features/onboarding/presentation/blocs/sign_up_token/sign_up_token_bloc.dart';
import 'package:uit_buddy_mobile/features/onboarding/presentation/screen/otp_screen.dart';
import 'package:uit_buddy_mobile/features/onboarding/presentation/screen/reset_password_screen.dart';
import 'package:uit_buddy_mobile/features/onboarding/presentation/screen/sign_in_screen.dart';
import 'package:uit_buddy_mobile/features/onboarding/presentation/screen/sign_up_info_screen.dart';
import 'package:uit_buddy_mobile/features/onboarding/presentation/screen/sign_up_token_screen.dart';
import 'package:uit_buddy_mobile/features/onboarding/presentation/screen/welcome_screen.dart';
import 'package:uit_buddy_mobile/features/root/screens/wrapper_screen.dart';

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
        child: BlocProvider(
          create: (_) => serviceLocator<SignUpTokenBloc>(),
          child: const SignUpTokenScreen(),
        ),
      ),
    ),
    GoRoute(
      path: RouteName.signUpInfo,
      pageBuilder: (context, state) {
        final studentId = state.pathParameters['studentId'] ?? '';
        final studentName = Uri.decodeComponent(
          state.pathParameters['studentName'] ?? '',
        );
        final signupToken = Uri.decodeComponent(
          state.pathParameters['signupToken'] ?? '',
        );
        return buildFlexibleSlideTransition(
          context: context,
          state: state,
          child: BlocProvider(
            create: (_) => serviceLocator<SignUpInfoBloc>(),
            child: SignUpInfoScreen(
              studentId: studentId,
              studentFullName: studentName,
              signupToken: signupToken,
            ),
          ),
        );
      },
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
    GoRoute(
      path: RouteName.home,
      pageBuilder: (context, state) => buildFlexibleSlideTransition(
        context: context,
        state: state,
        child: const WrapperScreen(),
      ),
    ),
  ],
);

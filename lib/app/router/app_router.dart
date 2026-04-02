import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:uit_buddy_mobile/app/di/app_dependencies.dart';
import 'package:uit_buddy_mobile/app/router/route_name.dart';
import 'package:uit_buddy_mobile/app/router/transitions/slide_transition.dart';
import 'package:uit_buddy_mobile/core/common/token/token_store.dart';
import 'package:uit_buddy_mobile/features/onboarding/presentation/blocs/sign_up_info/sign_up_info_bloc.dart';
import 'package:uit_buddy_mobile/features/onboarding/presentation/blocs/sign_up_token/sign_up_token_bloc.dart';
import 'package:uit_buddy_mobile/features/notification/presentation/screens/notification_screen.dart';
import 'package:uit_buddy_mobile/features/onboarding/presentation/screen/otp_screen.dart';
import 'package:uit_buddy_mobile/features/onboarding/presentation/screen/reset_password_screen.dart';
import 'package:uit_buddy_mobile/features/onboarding/presentation/screen/sign_in_screen.dart';
import 'package:uit_buddy_mobile/features/onboarding/presentation/screen/sign_up_info_screen.dart';
import 'package:uit_buddy_mobile/features/onboarding/presentation/screen/sign_up_token_screen.dart';
import 'package:uit_buddy_mobile/features/onboarding/presentation/screen/welcome_screen.dart';
import 'package:uit_buddy_mobile/features/profile/domain/entities/task_entity.dart';
import 'package:uit_buddy_mobile/features/profile/domain/entities/your_info_entity.dart';
import 'package:uit_buddy_mobile/features/profile/presentation/screens/add_edit_task_screen.dart';
import 'package:uit_buddy_mobile/features/profile/presentation/screens/edit_your_info_screen.dart';
import 'package:uit_buddy_mobile/features/profile/presentation/screens/groups_screen.dart';
import 'package:uit_buddy_mobile/features/profile/presentation/screens/settings_screen.dart';
import 'package:uit_buddy_mobile/features/profile/presentation/screens/task_detail_screen.dart';
import 'package:uit_buddy_mobile/features/profile/presentation/screens/tasks_screen.dart';
import 'package:uit_buddy_mobile/features/profile/presentation/screens/your_info_screen.dart';
import 'package:uit_buddy_mobile/features/profile/presentation/screens/your_posts_screen.dart';
import 'package:uit_buddy_mobile/features/profile/presentation/screens/academic_detail_screen.dart';
import 'package:uit_buddy_mobile/features/profile/presentation/screens/semester_detail_screen.dart';
import 'package:uit_buddy_mobile/features/home/presentation/screens/note_screen.dart';
import 'package:uit_buddy_mobile/features/home/presentation/screens/website_screen.dart';
import 'package:uit_buddy_mobile/features/home/presentation/screens/weather_screen.dart';
import 'package:uit_buddy_mobile/features/root/screens/wrapper_screen.dart';
import 'package:uit_buddy_mobile/features/chat/presentation/screens/chat_list_screen.dart';
import 'package:uit_buddy_mobile/features/chat/presentation/screens/chat_conversation_screen.dart';
import 'package:uit_buddy_mobile/features/chat/presentation/screens/chat_search_screen.dart';
import 'package:uit_buddy_mobile/features/chat/presentation/screens/chat_contacts_screen.dart';
import 'package:cometchat_chat_uikit/cometchat_chat_uikit.dart';
final _rootNavigatorKey = GlobalKey<NavigatorState>();
final goRouter = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: RouteName.welcome,
  redirect: (context, state) {
    final tokenStore = serviceLocator<TokenStore>();
    final onAuthFlow =
        state.matchedLocation == RouteName.welcome ||
        state.matchedLocation == RouteName.signIn;
    // If a persisted session exists, skip auth screens and go straight to home.
    if (tokenStore.hasSession && onAuthFlow) {
      return RouteName.home;
    }
    return null;
  },
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
        final studentName = state.pathParameters['studentName'] ?? '';
        final signupToken = state.pathParameters['signupToken'] ?? '';
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
      pageBuilder: (context, state) {
        final mssv = state.pathParameters['mssv'] ?? '';
        final otpCode = state.pathParameters['otpCode'] ?? '';
        return buildFlexibleSlideTransition(
          context: context,
          state: state,
          child: ResetPasswordScreen(mssv: mssv, otpCode: otpCode),
        );
      },
    ),
    GoRoute(
      path: RouteName.home,
      pageBuilder: (context, state) => buildFlexibleSlideTransition(
        context: context,
        state: state,
        child: const WrapperScreen(),
      ),
    ),
    GoRoute(
      path: RouteName.notification,
      pageBuilder: (context, state) => buildFlexibleSlideTransition(
        context: context,
        state: state,
        child: const NotificationScreen(),
      ),
    ),
    GoRoute(
      path: RouteName.tasks,
      pageBuilder: (context, state) => buildFlexibleSlideTransition(
        context: context,
        state: state,
        child: const TasksScreen(),
      ),
    ),
    GoRoute(
      path: RouteName.taskDetail,
      pageBuilder: (context, state) {
        final extra = state.extra as Map<String, dynamic>?;
        final task = extra?['task'] as TaskEntity?;
        return buildFlexibleSlideTransition(
          context: context,
          state: state,
          child: TaskDetailScreen(task: task!),
        );
      },
    ),
    GoRoute(
      path: RouteName.addEditTask,
      pageBuilder: (context, state) {
        final extra = state.extra as Map<String, dynamic>?;
        final task = extra?['task'] as TaskEntity?;
        return buildFlexibleSlideTransition(
          context: context,
          state: state,
          child: AddEditTaskScreen(existingTask: task),
        );
      },
    ),
    GoRoute(
      path: RouteName.yourInfo,
      pageBuilder: (context, state) => buildFlexibleSlideTransition(
        context: context,
        state: state,
        child: const YourInfoScreen(),
      ),
    ),
    GoRoute(
      path: RouteName.editYourInfo,
      pageBuilder: (context, state) {
        final extra = state.extra as Map<String, dynamic>?;
        final info = extra?['info'] as YourInfoEntity?;
        return buildFlexibleSlideTransition(
          context: context,
          state: state,
          child: EditYourInfoScreen(info: info!),
        );
      },
    ),
    GoRoute(
      path: RouteName.groupsJoined,
      pageBuilder: (context, state) {
        return buildFlexibleSlideTransition(
          context: context,
          state: state,
          child: GroupsScreen(),
        );
      },
    ),
    GoRoute(
      path: RouteName.yourPosts,
      pageBuilder: (context, state) {
        return buildFlexibleSlideTransition(
          context: context,
          state: state,
          child: YourPostsScreen(),
        );
      },
    ),
    GoRoute(
      path: RouteName.academicDetail,
      pageBuilder: (context, state) {
        return buildFlexibleSlideTransition(
          context: context,
          state: state,
          child: const AcademicDetailScreen(),
        );
      },
    ),
    GoRoute(
      path: RouteName.semesterDetail,
      pageBuilder: (context, state) {
        return buildFlexibleSlideTransition(
          context: context,
          state: state,
          child: const SemesterDetailScreen(),
        );
      },
    ),
    GoRoute(
      path: RouteName.settings,
      pageBuilder: (context, state) {
        return buildFlexibleSlideTransition(
          context: context,
          state: state,
          child: const SettingsScreen(),
        );
      },
    ),
    GoRoute(
      path: RouteName.note,
      pageBuilder: (context, state) => buildFlexibleSlideTransition(
        context: context,
        state: state,
        child: const NoteScreen(),
      ),
    ),
    GoRoute(
      path: RouteName.website,
      pageBuilder: (context, state) => buildFlexibleSlideTransition(
        context: context,
        state: state,
        child: const WebsiteScreen(),
      ),
    ),
    GoRoute(
      path: RouteName.weather,
      pageBuilder: (context, state) => buildFlexibleSlideTransition(
        context: context,
        state: state,
        child: const WeatherScreen(),
      ),
    ),
    GoRoute(
      path: RouteName.chat,
      pageBuilder: (context, state) => buildFlexibleSlideTransition(
        context: context,
        state: state,
        child: const ChatListScreen(),
      ),
    ),
    GoRoute(
      path: RouteName.chatConversation,
      pageBuilder: (context, state) {
        final extra = state.extra as Map<String, dynamic>?;
        final user = extra?['user'] as User?;
        final group = extra?['group'] as Group?;
        final message = extra?['message'] as BaseMessage?;
        return buildFlexibleSlideTransition(
          context: context,
          state: state,
          child: ChatConversationScreen(
            user: user,
            group: group,
            message: message,
          ),
        );
      },
    ),
    GoRoute(
      path: RouteName.chatSearch,
      pageBuilder: (context, state) => buildFlexibleSlideTransition(
        context: context,
        state: state,
        child: const ChatSearchScreen(),
      ),
    ),
    GoRoute(
      path: RouteName.chatContacts,
      pageBuilder: (context, state) => buildFlexibleSlideTransition(
        context: context,
        state: state,
        child: const ChatContactsScreen(),
      ),
    ),
  ],
);

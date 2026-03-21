import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:uit_buddy_mobile/app/router/app_router.dart';
import 'package:uit_buddy_mobile/app/router/route_name.dart';
import 'package:uit_buddy_mobile/core/common/token/refresh_token_datasource.dart';
import 'package:uit_buddy_mobile/core/common/token/refresh_token_datasource_impl.dart';
import 'package:uit_buddy_mobile/core/common/token/token_store.dart';
import 'package:uit_buddy_mobile/core/common/token/token_store_impl.dart';
import 'package:uit_buddy_mobile/core/config/app_env.dart';
import 'package:uit_buddy_mobile/core/network/http_client.dart';
import 'package:uit_buddy_mobile/core/storages/secure_storage.dart';
import 'package:uit_buddy_mobile/features/calendar/data/datasources/calendar_datasource_interface.dart';
import 'package:uit_buddy_mobile/features/calendar/data/datasources/course_datasource_interface.dart';
import 'package:uit_buddy_mobile/features/calendar/data/datasources/impl/calendar_datasource_impl.dart';
import 'package:uit_buddy_mobile/features/calendar/data/datasources/impl/course_datasource_impl.dart';
import 'package:uit_buddy_mobile/features/calendar/data/repositories/calendar_repository_impl.dart';
import 'package:uit_buddy_mobile/features/calendar/data/repositories/course_repository_impl.dart';
import 'package:uit_buddy_mobile/features/calendar/domain/repositories/calendar_repository.dart';
import 'package:uit_buddy_mobile/features/calendar/domain/repositories/course_repository.dart';
import 'package:uit_buddy_mobile/features/calendar/domain/usecases/get_deadline_usecase.dart';
import 'package:uit_buddy_mobile/features/calendar/domain/usecases/create_deadline_usecase.dart';
import 'package:uit_buddy_mobile/features/calendar/domain/usecases/get_courses_usecase.dart';
import 'package:uit_buddy_mobile/features/calendar/domain/usecases/get_courses_mode_usecase.dart';
import 'package:uit_buddy_mobile/features/calendar/domain/usecases/search_courses_usecase.dart';
import 'package:uit_buddy_mobile/features/calendar/presentation/bloc/add_deadline/add_deadline_bloc.dart';
import 'package:uit_buddy_mobile/features/calendar/presentation/bloc/calendar_screen/calendar_bloc.dart';
import 'package:uit_buddy_mobile/features/calendar/presentation/bloc/courses_mode/courses_mode_bloc.dart';
import 'package:uit_buddy_mobile/features/calendar/presentation/bloc/deadline_mode/deadline_bloc.dart';
import 'package:uit_buddy_mobile/features/notification/data/datasources/impl/notification_datasource_impl.dart';
import 'package:uit_buddy_mobile/features/notification/data/datasources/notification_datasource_interface.dart';
import 'package:uit_buddy_mobile/features/notification/data/repositories/notification_repository_impl.dart';
import 'package:uit_buddy_mobile/features/notification/domain/repositories/notification_repository.dart';
import 'package:uit_buddy_mobile/features/notification/domain/usecases/notification_usecase.dart';
import 'package:uit_buddy_mobile/features/notification/presentation/bloc/notification_screen/notification_bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:uit_buddy_mobile/features/onboarding/data/datasources/auth_remote_datasource.dart';
import 'package:uit_buddy_mobile/features/onboarding/data/datasources/firebase_remote_datasource.dart';
import 'package:uit_buddy_mobile/features/onboarding/data/datasources/impl/auth_remote_datasource_impl.dart';
import 'package:uit_buddy_mobile/features/onboarding/data/repositories/auth_repository_impl.dart';
import 'package:uit_buddy_mobile/features/onboarding/data/repositories/firebase_repository_impl.dart';
import 'package:uit_buddy_mobile/features/onboarding/domain/repositories/auth_repository.dart';
import 'package:uit_buddy_mobile/features/onboarding/domain/repositories/firebase_repository.dart';
import 'package:uit_buddy_mobile/features/onboarding/domain/usecases/forget_password_usecase.dart';
import 'package:uit_buddy_mobile/features/onboarding/domain/usecases/reset_password_usecase.dart';
import 'package:uit_buddy_mobile/features/onboarding/domain/usecases/signin_usecase.dart';
import 'package:uit_buddy_mobile/features/onboarding/domain/usecases/signup_complete_usecase.dart';
import 'package:uit_buddy_mobile/features/onboarding/domain/usecases/signup_init_usecase.dart';
import 'package:uit_buddy_mobile/features/onboarding/presentation/blocs/otp/otp_bloc.dart';
import 'package:uit_buddy_mobile/features/onboarding/presentation/blocs/reset_password/reset_password_bloc.dart';
import 'package:uit_buddy_mobile/features/onboarding/presentation/blocs/sign_in/sign_in_bloc.dart';
import 'package:uit_buddy_mobile/features/onboarding/presentation/blocs/sign_up_info/sign_up_info_bloc.dart';
import 'package:uit_buddy_mobile/features/onboarding/presentation/blocs/sign_up_token/sign_up_token_bloc.dart';
import 'package:uit_buddy_mobile/features/profile/data/datasources/group_datasource_interface.dart';
import 'package:uit_buddy_mobile/features/profile/data/datasources/delete_account_datasource_interface.dart';
import 'package:uit_buddy_mobile/features/profile/data/datasources/impl/delete_account_datasource_impl.dart';
import 'package:uit_buddy_mobile/features/profile/data/datasources/impl/group_datasource_impl.dart';
import 'package:uit_buddy_mobile/features/profile/data/datasources/impl/post_datasource_impl.dart';
import 'package:uit_buddy_mobile/features/profile/data/datasources/impl/profile_datasource_impl.dart';
import 'package:uit_buddy_mobile/features/profile/data/datasources/impl/sign_out_datasource_impl.dart';
import 'package:uit_buddy_mobile/features/profile/data/datasources/impl/task_datasource_impl.dart';
import 'package:uit_buddy_mobile/features/profile/data/datasources/impl/your_info_datasource_impl.dart';
import 'package:uit_buddy_mobile/features/profile/data/datasources/post_datasource_interface.dart';
import 'package:uit_buddy_mobile/features/profile/data/datasources/profile_datasource_interface.dart';
import 'package:uit_buddy_mobile/features/profile/data/datasources/sign_out_datasource_interface.dart';
import 'package:uit_buddy_mobile/features/profile/data/datasources/task_datasource_interface.dart';
import 'package:uit_buddy_mobile/features/profile/data/datasources/your_info_datasource_interface.dart';
import 'package:uit_buddy_mobile/features/profile/data/repositories/group_repository_impl.dart';
import 'package:uit_buddy_mobile/features/profile/data/repositories/post_repository_impl.dart';
import 'package:uit_buddy_mobile/features/profile/data/repositories/profile_repository_impl.dart';
import 'package:uit_buddy_mobile/features/profile/data/repositories/settings_repository_impl.dart';
import 'package:uit_buddy_mobile/features/profile/data/repositories/sign_out_repository_impl.dart';
import 'package:uit_buddy_mobile/features/profile/data/repositories/task_repository_impl.dart';
import 'package:uit_buddy_mobile/features/profile/data/repositories/your_info_repository_impl.dart';
import 'package:uit_buddy_mobile/features/profile/domain/repositories/group_repository.dart';
import 'package:uit_buddy_mobile/features/profile/domain/repositories/post_repository.dart';
import 'package:uit_buddy_mobile/features/profile/domain/repositories/profile_repository.dart';
import 'package:uit_buddy_mobile/features/profile/domain/repositories/settings_repository.dart';
import 'package:uit_buddy_mobile/features/profile/domain/repositories/sign_out_repository.dart';
import 'package:uit_buddy_mobile/features/profile/domain/repositories/task_repository.dart';
import 'package:uit_buddy_mobile/features/profile/domain/repositories/your_info_repository.dart';
import 'package:uit_buddy_mobile/features/profile/domain/repositories/academic_detail_repository.dart';
import 'package:uit_buddy_mobile/features/profile/domain/repositories/semester_detail_repository.dart';
import 'package:uit_buddy_mobile/features/profile/data/repositories/academic_detail_repository_impl.dart';
import 'package:uit_buddy_mobile/features/profile/data/repositories/semester_detail_repository_impl.dart';
import 'package:uit_buddy_mobile/features/profile/domain/usecases/get_academic_detail_usecase.dart';
import 'package:uit_buddy_mobile/features/profile/domain/usecases/get_semester_detail_usecase.dart';
import 'package:uit_buddy_mobile/features/profile/presentation/bloc/academic_detail_screen/academic_detail_bloc.dart';
import 'package:uit_buddy_mobile/features/profile/presentation/bloc/semester_detail_screen/semester_detail_bloc.dart';
import 'package:uit_buddy_mobile/features/profile/domain/usecases/create_task_usecase.dart';
import 'package:uit_buddy_mobile/features/profile/domain/usecases/delete_account_usecase.dart';
import 'package:uit_buddy_mobile/features/profile/domain/usecases/delete_task_usecase.dart';
import 'package:uit_buddy_mobile/features/profile/domain/usecases/get_groups_usecase.dart';
import 'package:uit_buddy_mobile/features/profile/domain/usecases/get_posts_usecase.dart';
import 'package:uit_buddy_mobile/features/profile/domain/usecases/get_profile_usecase.dart';
import 'package:uit_buddy_mobile/features/profile/domain/usecases/get_tasks_usecase.dart';
import 'package:uit_buddy_mobile/features/profile/domain/usecases/get_your_info_usecase.dart';
import 'package:uit_buddy_mobile/features/profile/domain/usecases/mark_task_completed_usecase.dart';
import 'package:uit_buddy_mobile/features/profile/domain/usecases/sign_out_usecase.dart';
import 'package:uit_buddy_mobile/features/profile/domain/usecases/update_task_usecase.dart';
import 'package:uit_buddy_mobile/features/profile/domain/usecases/update_your_info_usecase.dart';
import 'package:uit_buddy_mobile/features/profile/presentation/bloc/group_screen/group_bloc.dart';
import 'package:uit_buddy_mobile/features/profile/presentation/bloc/profile_screen/profile_bloc.dart';
import 'package:uit_buddy_mobile/features/profile/presentation/bloc/settings_screen/settings_bloc.dart';
import 'package:uit_buddy_mobile/features/profile/presentation/bloc/tasks_screen/tasks_bloc.dart';
import 'package:uit_buddy_mobile/features/profile/presentation/bloc/your_info_screen/your_info_bloc.dart';
import 'package:uit_buddy_mobile/features/profile/presentation/bloc/your_posts_screen/your_posts_bloc.dart';
import 'package:uit_buddy_mobile/features/session/data/datasources/impl/session_datasource_impl.dart';
import 'package:uit_buddy_mobile/features/session/data/datasources/session_datasource_interface.dart';
import 'package:uit_buddy_mobile/features/session/data/repositories/session_repository_impl.dart';
import 'package:uit_buddy_mobile/features/session/domain/repositories/session_repository.dart';
import 'package:uit_buddy_mobile/features/session/domain/usecases/get_current_user_usecase.dart';
import 'package:uit_buddy_mobile/features/session/presentation/bloc/session_bloc.dart';
import 'package:uit_buddy_mobile/features/social/data/datasources/comment_datasource_interface.dart';
import 'package:uit_buddy_mobile/features/social/data/datasources/impl/comment_datasource_impl.dart';
import 'package:uit_buddy_mobile/features/social/data/datasources/impl/post_datasource_impl.dart';
import 'package:uit_buddy_mobile/features/social/data/datasources/impl/reaction_datasource_impl.dart';
import 'package:uit_buddy_mobile/features/social/data/datasources/post_datasource_interface.dart';
import 'package:uit_buddy_mobile/features/social/data/datasources/reaction_datasource_interface.dart';
import 'package:uit_buddy_mobile/features/social/data/repositories/comment_repository_impl.dart';
import 'package:uit_buddy_mobile/features/social/data/repositories/post_repository_impl.dart';
import 'package:uit_buddy_mobile/features/social/data/repositories/reaction_repository_impl.dart';
import 'package:uit_buddy_mobile/features/social/domain/repositories/comment_repository.dart';
import 'package:uit_buddy_mobile/features/social/domain/repositories/post_repository.dart';
import 'package:uit_buddy_mobile/features/social/domain/repositories/reaction_repository.dart';
import 'package:uit_buddy_mobile/features/social/domain/usecases/create_comment_usecase.dart';
import 'package:uit_buddy_mobile/features/social/domain/usecases/create_post_usecase.dart';
import 'package:uit_buddy_mobile/features/social/domain/usecases/delete_comment_usecase.dart';
import 'package:uit_buddy_mobile/features/social/domain/usecases/delete_post_usecase.dart';
import 'package:uit_buddy_mobile/features/social/domain/usecases/get_comment_replies_usecase.dart';
import 'package:uit_buddy_mobile/features/social/domain/usecases/get_newfeed_usecase.dart';
import 'package:uit_buddy_mobile/features/social/domain/usecases/get_post_comments_usecase.dart';
import 'package:uit_buddy_mobile/features/social/domain/usecases/get_post_detail_usecase.dart';
import 'package:uit_buddy_mobile/features/social/domain/usecases/reply_to_comment_usecase.dart';
import 'package:uit_buddy_mobile/features/social/domain/usecases/toggle_comment_like_usecase.dart';
import 'package:uit_buddy_mobile/features/social/domain/usecases/toggle_like_usecase.dart';
import 'package:uit_buddy_mobile/features/social/domain/usecases/update_post_usecase.dart';
import 'package:uit_buddy_mobile/features/social/presentation/bloc/chat_settings/chat_settings_bloc.dart';
import 'package:uit_buddy_mobile/features/social/presentation/bloc/contact_picker/contact_picker_bloc.dart';
import 'package:uit_buddy_mobile/features/social/presentation/bloc/edit_post/edit_post_bloc.dart';
import 'package:uit_buddy_mobile/features/social/presentation/bloc/new_feed/new_feed_bloc.dart';
import 'package:uit_buddy_mobile/features/social/presentation/bloc/post_detail/post_detail_bloc.dart';
import 'package:uit_buddy_mobile/features/storage/data/datasources/document_datasource_interface.dart';
import 'package:uit_buddy_mobile/features/storage/data/datasources/impl/document_datasource_impl.dart';
import 'package:uit_buddy_mobile/features/storage/data/datasources/impl/subject_class_datasource_impl.dart';
import 'package:uit_buddy_mobile/features/storage/data/datasources/subject_class_datasource_interface.dart';
import 'package:uit_buddy_mobile/features/storage/data/repositories/document_repository_impl.dart';
import 'package:uit_buddy_mobile/features/storage/data/repositories/subject_class_repository_impl.dart';
import 'package:uit_buddy_mobile/features/storage/domain/repositories/document_repository.dart';
import 'package:uit_buddy_mobile/features/storage/domain/repositories/subject_class_repository.dart';
import 'package:uit_buddy_mobile/features/storage/domain/usecases/document_usecase.dart';
import 'package:uit_buddy_mobile/features/storage/domain/usecases/subject_class_usecase.dart';
import 'package:uit_buddy_mobile/features/storage/presentation/bloc/storage_bloc.dart';

final serviceLocator = GetIt.instance;

Future<void> initDependencies() async {
  await Firebase.initializeApp();
  await _initAuthDependencies();
  _initSessionDependencies();
  await _initCalendarDependencies();
  await _initProfileDependencies();
  await _initNotificationDependencies();
  await _initStorageDependencies();
  _initSocialDependencies();
  await _initGroupsDependencies();
  await _initSettingsDependencies();
  // await _initYourPostsDependencies();
}

Future<void> _initAuthDependencies() async {
  // Storage — eagerly created so we can load persisted tokens before the app renders
  final secureStore = SecureStore();
  serviceLocator.registerSingleton<SecureStore>(secureStore);

  final tokenStore = TokenStoreImpl(secureStore: secureStore);
  await tokenStore.loadPersistedTokens();
  serviceLocator.registerSingleton<TokenStore>(tokenStore);

  // Public Dio client (no auth interceptor needed for signup/signin/refresh)
  serviceLocator.registerLazySingleton<Dio>(() {
    final dio = Dio(
      BaseOptions(
        baseUrl: AppEnv.baseUrl,
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
        headers: {
          'Content-Type': 'application/json',
          'ngrok-skip-browser-warning': 'true',
        },
      ),
    );
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          log(
            '${options.method} ${options.baseUrl}${options.path}\nheaders: ${options.headers}\nbody: ${options.data}',
            name: 'publicDio',
          );
          handler.next(options);
        },
        onResponse: (response, handler) {
          log(
            '${response.statusCode} ${response.requestOptions.method} ${response.requestOptions.uri}\nbody: ${response.data}',
            name: 'publicDio',
          );
          handler.next(response);
        },
        onError: (error, handler) {
          final uri = error.requestOptions.uri;
          final method = error.requestOptions.method;
          final statusCode = error.response?.statusCode;
          final errorType = error.type.name;
          final responseData = error.response?.data;

          log(
            'HTTP ERROR\n'
            'Method: $method\n'
            'URL: $uri\n'
            'Status Code: $statusCode\n'
            'Error Type: $errorType\n'
            'Error Message: ${error.message}\n'
            'Response Data: $responseData',
            name: 'publicDio',
            error: error,
            stackTrace: error.stackTrace,
          );
          handler.next(error);
        },
      ),
    );
    dio.interceptors.add(
      LogInterceptor(
        requestBody: true,
        responseBody: true,
        logPrint: (o) => log('$o', name: 'publicDio'),
      ),
    );
    return dio;
  }, instanceName: 'publicDio');

  // Refresh token datasource (uses publicDio — no circular auth interceptor)
  serviceLocator.registerLazySingleton<RefreshTokenDataSource>(
    () => RefreshTokenDataSourceImpl(
      dio: serviceLocator(instanceName: 'publicDio'),
    ),
  );

  // Authenticated Dio client (with AuthRefreshInterceptor)
  serviceLocator.registerLazySingleton<Dio>(() {
    return HttpClient(
      tokenStore: serviceLocator(),
      refreshTokenDataSource: serviceLocator(),
    ).createDioClient(
      AppEnv.baseUrl,
      onSessionExpired: () => goRouter.go(RouteName.signIn),
    );
  }, instanceName: 'authenticatedDio');

  // Firebase datasource & repository
  serviceLocator.registerLazySingleton<FirebaseRemoteDatasource>(
    () => FirebaseRemoteDatasourceImpl(FirebaseMessaging.instance),
  );
  serviceLocator.registerLazySingleton<FirebaseRepository>(
    () => FirebaseRepositoryImpl(serviceLocator()),
  );

  // Datasource
  serviceLocator.registerLazySingleton<AuthRemoteDatasource>(
    () => AuthRemoteDatasourceImpl(
      dio: serviceLocator(instanceName: 'publicDio'),
    ),
  );

  // Repository
  serviceLocator.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(
      authRemoteDatasource: serviceLocator(),
      tokenStore: serviceLocator(),
    ),
  );

  // Usecases
  serviceLocator.registerLazySingleton(
    () => SignUpInitUsecase(authRepository: serviceLocator()),
  );
  serviceLocator.registerLazySingleton(
    () => SignUpCompleteUsecase(
      authRepository: serviceLocator(),
      firebaseRepository: serviceLocator(),
    ),
  );
  serviceLocator.registerLazySingleton(
    () => SignInUsecase(
      authRepository: serviceLocator(),
      firebaseRepository: serviceLocator(),
    ),
  );
  serviceLocator.registerLazySingleton(
    () => ForgetPasswordUsecase(authRepository: serviceLocator()),
  );
  serviceLocator.registerLazySingleton(
    () => ResetPasswordUsecase(authRepository: serviceLocator()),
  );

  // Blocs
  serviceLocator.registerFactory(
    () => SignUpTokenBloc(signUpInitUsecase: serviceLocator()),
  );
  serviceLocator.registerFactory(
    () => SignUpInfoBloc(signUpCompleteUsecase: serviceLocator()),
  );
  serviceLocator.registerFactory(
    () => SignInBloc(signInUsecase: serviceLocator()),
  );
  serviceLocator.registerFactory(
    () => OtpBloc(forgetPasswordUsecase: serviceLocator()),
  );
  serviceLocator.registerFactory(
    () => ResetPasswordBloc(resetPasswordUsecase: serviceLocator()),
  );
}

void _initSessionDependencies() {
  // Datasource — uses authenticatedDio since /api/user/me requires a token
  serviceLocator.registerLazySingleton<SessionDatasourceInterface>(
    () => SessionDatasourceImpl(
      dio: serviceLocator(instanceName: 'authenticatedDio'),
    ),
  );

  // Repository
  serviceLocator.registerLazySingleton<SessionRepository>(
    () => SessionRepositoryImpl(datasource: serviceLocator()),
  );

  // Usecase
  serviceLocator.registerLazySingleton(
    () => GetCurrentUserUsecase(repository: serviceLocator()),
  );

  // Bloc — singleton so the same instance is shared across the whole app
  serviceLocator.registerLazySingleton(
    () => SessionBloc(getCurrentUserUsecase: serviceLocator()),
  );
}

Future<void> _initCalendarDependencies() async {
  // Datasources
  serviceLocator.registerLazySingleton<CalendarDatasourceInterface>(
    () => CalendarDatasourceImpl(),
  );
  serviceLocator.registerLazySingleton<CourseDatasourceInterface>(
    () => CourseDatasourceImpl(),
  );

  // Repositories
  serviceLocator.registerLazySingleton<CalendarRepository>(
    () => CalendarRepositoryImpl(calendarDatasourceInterface: serviceLocator()),
  );
  serviceLocator.registerLazySingleton<CourseRepository>(
    () => CourseRepositoryImpl(courseDatasourceInterface: serviceLocator()),
  );

  // Usecases
  serviceLocator.registerLazySingleton(
    () => GetDeadlineUsecase(calendarRepository: serviceLocator()),
  );
  serviceLocator.registerLazySingleton(
    () => GetCoursesUsecase(courseRepository: serviceLocator()),
  );
  serviceLocator.registerLazySingleton(() => SearchCoursesUsecase());
  serviceLocator.registerLazySingleton(
    () => CreateDeadlineUsecase(calendarRepository: serviceLocator()),
  );
  serviceLocator.registerLazySingleton(
    () => GetCoursesModeUsecase(courseRepository: serviceLocator()),
  );

  // Blocs / Cubits
  serviceLocator.registerFactory(() => CalendarBloc());
  serviceLocator.registerFactory(
    () => DeadlineBloc(getDeadlineUsecase: serviceLocator()),
  );
  serviceLocator.registerFactory(
    () => CoursesModeBloc(getCoursesModeUsecase: serviceLocator()),
  );
  serviceLocator.registerFactory(
    () => AddDeadlineBloc(
      getCoursesUsecase: serviceLocator(),
      searchCoursesUsecase: serviceLocator(),
      createDeadlineUsecase: serviceLocator(),
    ),
  );
}

void _initSocialDependencies() {
  // Datasources
  serviceLocator.registerLazySingleton<PostDatasourceInterface>(
    () => PostDatasourceImpl(
      dio: serviceLocator(instanceName: 'authenticatedDio'),
    ),
  );
  serviceLocator.registerLazySingleton<CommentDatasourceInterface>(
    () => CommentDatasourceImpl(
      dio: serviceLocator(instanceName: 'authenticatedDio'),
    ),
  );
  serviceLocator.registerLazySingleton<ReactionDatasourceInterface>(
    () => ReactionDatasourceImpl(
      dio: serviceLocator(instanceName: 'authenticatedDio'),
    ),
  );

  // Repositories
  serviceLocator.registerLazySingleton<PostRepository>(
    () => PostRepositoryImpl(datasource: serviceLocator()),
  );
  serviceLocator.registerLazySingleton<CommentRepository>(
    () => CommentRepositoryImpl(datasource: serviceLocator()),
  );
  serviceLocator.registerLazySingleton<ReactionRepository>(
    () => ReactionRepositoryImpl(datasource: serviceLocator()),
  );

  // Usecases — Post
  serviceLocator.registerLazySingleton(
    () => GetNewfeedUsecase(repository: serviceLocator()),
  );
  serviceLocator.registerLazySingleton(
    () => CreatePostUsecase(repository: serviceLocator()),
  );
  serviceLocator.registerLazySingleton(
    () => DeletePostUsecase(repository: serviceLocator()),
  );
  serviceLocator.registerLazySingleton(
    () => GetPostDetailUsecase(repository: serviceLocator()),
  );

  // Usecases — Reaction
  serviceLocator.registerLazySingleton(
    () => ToggleLikeUsecase(repository: serviceLocator()),
  );
  serviceLocator.registerLazySingleton(
    () => ToggleCommentLikeUsecase(repository: serviceLocator()),
  );

  // Usecases — Comment
  serviceLocator.registerLazySingleton(
    () => GetPostCommentsUsecase(repository: serviceLocator()),
  );
  serviceLocator.registerLazySingleton(
    () => CreateCommentUsecase(repository: serviceLocator()),
  );
  serviceLocator.registerLazySingleton(
    () => ReplyToCommentUsecase(repository: serviceLocator()),
  );
  serviceLocator.registerLazySingleton(
    () => DeleteCommentUsecase(repository: serviceLocator()),
  );
  serviceLocator.registerLazySingleton(
    () => GetCommentRepliesUsecase(repository: serviceLocator()),
  );
  serviceLocator.registerLazySingleton(
    () => UpdatePostUsecase(repository: serviceLocator()),
  );

  // Blocs
  serviceLocator.registerFactory(
    () => EditPostBloc(updatePostUsecase: serviceLocator()),
  );
  serviceLocator.registerFactory(
    () => NewFeedBloc(
      getNewfeedUsecase: serviceLocator(),
      createPostUsecase: serviceLocator(),
      deletePostUsecase: serviceLocator(),
      toggleLikeUsecase: serviceLocator(),
    ),
  );
  serviceLocator.registerFactory(
    () => PostDetailBloc(
      getPostDetailUsecase: serviceLocator(),
      getPostCommentsUsecase: serviceLocator(),
      createCommentUsecase: serviceLocator(),
      replyToCommentUsecase: serviceLocator(),
      deleteCommentUsecase: serviceLocator(),
      toggleCommentLikeUsecase: serviceLocator(),
      getCommentRepliesUsecase: serviceLocator(),
      toggleLikeUsecase: serviceLocator(),
    ),
  );
  serviceLocator.registerFactory(() => ChatSettingsBloc());
  serviceLocator.registerFactory(() => ContactPickerBloc());
}

Future<void> _initProfileDependencies() async {
  // Datasources
  serviceLocator.registerLazySingleton<ProfileDatasourceInterface>(
    () => ProfileInfoDatasourceImpl(
      dio: serviceLocator(instanceName: 'authenticatedDio'),
    ),
  );
  serviceLocator.registerLazySingleton<TaskDatasourceInterface>(
    () => TaskDatasourceImpl(),
  );
  serviceLocator.registerLazySingleton<YourInfoDatasourceInterface>(
    () => YourInfoDatasourceImpl(
      dio: serviceLocator(instanceName: 'authenticatedDio'),
    ),
  );
  serviceLocator.registerLazySingleton<ProfilePostDatasourceInterface>(
    () => ProfilePostDatasourceImpl(),
  );
  serviceLocator.registerLazySingleton<SignOutDatasource>(
    () => SignOutDatasourceImpl(
      dio: serviceLocator(instanceName: 'authenticatedDio'),
    ),
  );

  // Repositories
  serviceLocator.registerLazySingleton<ProfileRepository>(
    () => ProfileRepositoryImpl(profileDatasourceInterface: serviceLocator()),
  );
  serviceLocator.registerLazySingleton<TaskRepository>(
    () => TaskRepositoryImpl(taskDatasourceInterface: serviceLocator()),
  );
  serviceLocator.registerLazySingleton<YourInfoRepository>(
    () => YourInfoRepositoryImpl(yourInfoDatasourceInterface: serviceLocator()),
  );
  serviceLocator.registerLazySingleton<ProfilePostRepository>(
    () => ProfilePostRepositoryImpl(postDatasourceInterface: serviceLocator()),
  );
  serviceLocator.registerLazySingleton<SignOutRepository>(
    () => SignOutRepositoryImpl(
      signOutDatasource: serviceLocator(),
      tokenStore: serviceLocator(),
    ),
  );
  serviceLocator.registerLazySingleton<AcademicDetailRepository>(
    () => AcademicDetailRepositoryImpl(),
  );
  serviceLocator.registerLazySingleton<SemesterDetailRepository>(
    () => SemesterDetailRepositoryImpl(),
  );

  // Usecases
  serviceLocator.registerLazySingleton(
    () => GetProfileUsecase(profileRepository: serviceLocator()),
  );
  serviceLocator.registerLazySingleton(
    () => GetTasksUsecase(taskRepository: serviceLocator()),
  );
  serviceLocator.registerLazySingleton(
    () => MarkTaskCompletedUsecase(taskRepository: serviceLocator()),
  );
  serviceLocator.registerLazySingleton(
    () => DeleteTaskUsecase(taskRepository: serviceLocator()),
  );
  serviceLocator.registerLazySingleton(
    () => CreateTaskUsecase(taskRepository: serviceLocator()),
  );
  serviceLocator.registerLazySingleton(
    () => UpdateTaskUsecase(taskRepository: serviceLocator()),
  );
  serviceLocator.registerLazySingleton(
    () => GetYourInfoUsecase(repository: serviceLocator()),
  );
  serviceLocator.registerLazySingleton(
    () => UpdateYourInfoUsecase(repository: serviceLocator()),
  );
  serviceLocator.registerLazySingleton(
    () => GetPostsUsecase(postRepository: serviceLocator()),
  );
  serviceLocator.registerLazySingleton(
    () => SignOutUsecase(signOutRepository: serviceLocator()),
  );
  serviceLocator.registerLazySingleton(
    () => GetAcademicDetailsUsecase(academicDetailRepository: serviceLocator()),
  );
  serviceLocator.registerLazySingleton(
    () => GetSemesterDetailsUsecase(semesterDetailRepository: serviceLocator()),
  );

  // Blocs
  serviceLocator.registerFactory(
    () => ProfileBloc(
      getProfileUsecase: serviceLocator(),
      signOutUsecase: serviceLocator(),
    ),
  );
  serviceLocator.registerFactory(
    () => TasksBloc(
      getTasksUsecase: serviceLocator(),
      markTaskCompletedUsecase: serviceLocator(),
      deleteTaskUsecase: serviceLocator(),
      createTaskUsecase: serviceLocator(),
      updateTaskUsecase: serviceLocator(),
    ),
  );
  serviceLocator.registerFactory(
    () => YourInfoBloc(
      getYourInfoUsecase: serviceLocator(),
      updateYourInfoUsecase: serviceLocator(),
    ),
  );
  serviceLocator.registerFactory(
    () => YourPostsBloc(getPostsUsecase: serviceLocator()),
  );
  serviceLocator.registerFactory(
    () => AcademicDetailBloc(getAcademicDetailsUsecase: serviceLocator()),
  );
  serviceLocator.registerFactory(
    () => SemesterDetailBloc(getSemesterDetailsUsecase: serviceLocator()),
  );
}

Future<void> _initNotificationDependencies() async {
  // Datasource
  serviceLocator.registerLazySingleton<NotificationDatasourceInterface>(
    () => NotificationDatasourceImpl(),
  );

  // Repository
  serviceLocator.registerLazySingleton<NotificationRepository>(
    () => NotificationRepositoryImpl(
      notificationDatasourceInterface: serviceLocator(),
    ),
  );

  // Usecases
  serviceLocator.registerLazySingleton(
    () => GetNotificationUsecase(notificationRepository: serviceLocator()),
  );

  // Blocs
  serviceLocator.registerFactory(
    () => NotificationBloc(getNotificationUsecase: serviceLocator()),
  );
}

Future<void> _initStorageDependencies() async {
  // Datasources
  serviceLocator.registerLazySingleton<SubjectClassDatasourceInterface>(
    () => SubjectClassDatasourceImpl(),
  );
  serviceLocator.registerLazySingleton<DocumentDatasourceInterface>(
    () => DocumentDatasourceImpl(),
  );

  // Repositories
  serviceLocator.registerLazySingleton<SubjectClassRepository>(
    () => SubjectClassRepositoryImpl(
      subjectClassDatasourceInterface: serviceLocator(),
    ),
  );
  serviceLocator.registerLazySingleton<DocumentRepository>(
    () => DocumentRepositoryImpl(documentDatasourceInterface: serviceLocator()),
  );

  // Usecases
  serviceLocator.registerLazySingleton(
    () => SubjectClassUsecase(subjectClassRepository: serviceLocator()),
  );
  serviceLocator.registerLazySingleton(
    () => DocumentUsecase(documentRepository: serviceLocator()),
  );

  // Blocs
  serviceLocator.registerFactory(
    () => StorageBloc(
      subjectClassUsecase: serviceLocator(),
      documentUsecase: serviceLocator(),
    ),
  );
}

Future<void> _initGroupsDependencies() async {
  // Datasource
  serviceLocator.registerLazySingleton<GroupDatasourceInterface>(
    () => GroupDatasourceImpl(),
  );

  // Repository
  serviceLocator.registerLazySingleton<GroupRepository>(
    () => GroupRepositoryImpl(groupDatasourceInterface: serviceLocator()),
  );

  // Usecases
  serviceLocator.registerLazySingleton(
    () => GetGroupsUsecase(groupRepository: serviceLocator()),
  );

  // Blocs
  serviceLocator.registerFactory(
    () => GroupBloc(getGroupsUsecase: serviceLocator()),
  );
}

Future<void> _initSettingsDependencies() async {
  // Datasource
  serviceLocator.registerLazySingleton<DeleteAccountDatasource>(
    () => DeleteAccountDatasourceImpl(
      dio: serviceLocator(instanceName: 'authenticatedDio'),
    ),
  );

  // Repository
  serviceLocator.registerLazySingleton<SettingsRepository>(
    () => SettingsRepositoryImpl(
      deleteAccountDatasource: serviceLocator(),
      tokenStore: serviceLocator(),
    ),
  );

  // Usecase
  serviceLocator.registerLazySingleton(
    () => DeleteAccountUsecase(settingsRepository: serviceLocator()),
  );

  // Blocs
  serviceLocator.registerFactory(
    () => SettingsBloc(deleteAccountUsecase: serviceLocator()),
  );
}

// Future<void> _initYourPostsDependencies() async {
//   // Datasource
//   serviceLocator.registerLazySingleton<PostDatasourceInterface>(
//     () => PostDatasourceImpl(),
//   );

//   // Repository
//   serviceLocator.registerLazySingleton<PostRepository>(
//     () => PostRepositoryImpl(
//       postDatasourceInterface: serviceLocator(),
//     ),
//   );

//   // Usecases
//   serviceLocator.registerLazySingleton(
//     () => GetPostsUsecase(postRepository: serviceLocator()),
//   );

//   // Blocs
//   serviceLocator.registerFactory(
//     () => YourPostsBloc(getPostsUsecase: serviceLocator()),
//   );
// }

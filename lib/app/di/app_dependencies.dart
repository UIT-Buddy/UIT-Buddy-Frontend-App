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
import 'package:uit_buddy_mobile/features/calendar/data/datasources/impl/calendar_datasource_impl.dart';
import 'package:uit_buddy_mobile/features/calendar/data/repositories/calendar_repository_impl.dart';
import 'package:uit_buddy_mobile/features/calendar/domain/repositories/calendar_repository.dart';
import 'package:uit_buddy_mobile/features/calendar/domain/usecases/get_deadline_usecase.dart';
import 'package:uit_buddy_mobile/features/calendar/presentation/bloc/calendar_screen/calendar_bloc.dart';
import 'package:uit_buddy_mobile/features/calendar/presentation/bloc/deadline_mode/deadline_bloc.dart';
import 'package:uit_buddy_mobile/features/onboarding/data/datasources/auth_remote_datasource.dart';
import 'package:uit_buddy_mobile/features/onboarding/data/datasources/impl/auth_remote_datasource_impl.dart';
import 'package:uit_buddy_mobile/features/onboarding/data/repositories/auth_repository_impl.dart';
import 'package:uit_buddy_mobile/features/onboarding/domain/repositories/auth_repository.dart';
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
import 'package:uit_buddy_mobile/features/notification/data/datasources/impl/notification_datasource_impl.dart';
import 'package:uit_buddy_mobile/features/notification/data/datasources/notification_datasource_interface.dart';
import 'package:uit_buddy_mobile/features/notification/data/repositories/notification_repository_impl.dart';
import 'package:uit_buddy_mobile/features/notification/domain/repositories/notification_repository.dart';
import 'package:uit_buddy_mobile/features/notification/domain/usecases/notification_usecase.dart';
import 'package:uit_buddy_mobile/features/notification/presentation/bloc/notification_screen/notification_bloc.dart';
import 'package:uit_buddy_mobile/features/profile/data/datasources/impl/profile_datasource_impl.dart';
import 'package:uit_buddy_mobile/features/profile/data/datasources/profile_datasource_interface.dart';
import 'package:uit_buddy_mobile/features/profile/data/repositories/profile_repository_impl.dart';
import 'package:uit_buddy_mobile/features/profile/domain/repositories/profile_repository.dart';
import 'package:uit_buddy_mobile/features/profile/domain/usecases/get_profile_usecase.dart';
import 'package:uit_buddy_mobile/features/profile/presentation/bloc/profile_screen/profile_bloc.dart';
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
  await _initAuthDependencies();
  await _initCalendarDependencies();
  await _initProfileDependencies();
  await _initNotificationDependencies();
  await _initStorageDependencies();
}

Future<void> _initAuthDependencies() async {
  // Storage
  serviceLocator.registerLazySingleton<SecureStore>(() => SecureStore());
  serviceLocator.registerLazySingleton<TokenStore>(
    () => TokenStoreImpl(secureStore: serviceLocator()),
  );

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
          log(
            '${error.response?.statusCode} ${error.requestOptions.method} ${error.requestOptions.uri}\n${error.message}',
            name: 'publicDio',
            error: error,
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
    () => SignUpCompleteUsecase(authRepository: serviceLocator()),
  );
  serviceLocator.registerLazySingleton(
    () => SignInUsecase(authRepository: serviceLocator()),
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


Future<void> _initCalendarDependencies() async {
  // Datasource
  serviceLocator.registerLazySingleton<CalendarDatasourceInterface>(
    () => CalendarDatasourceImpl(),
  );

  // Repository
  serviceLocator.registerLazySingleton<CalendarRepository>(
    () => CalendarRepositoryImpl(calendarDatasourceInterface: serviceLocator()),
  );

  // Usecases
  serviceLocator.registerLazySingleton(
    () => GetDeadlineUsecase(calendarRepository: serviceLocator()),
  );

  // Blocs
  serviceLocator.registerFactory(() => CalendarBloc());

  serviceLocator.registerFactory(
    () => DeadlineBloc(getDeadlineUsecase: serviceLocator()),
  );
}

Future<void> _initProfileDependencies() async {
  // Datasource
  serviceLocator.registerLazySingleton<ProfileDatasourceInterface>(
    () => ProfileInfoDatasourceImpl(),
  );

  // Repository
  serviceLocator.registerLazySingleton<ProfileRepository>(
    () => ProfileRepositoryImpl(
      profileDatasourceInterface: serviceLocator(),
    ),
  );

  // Usecases
  serviceLocator.registerLazySingleton(
    () => GetProfileUsecase(profileRepository: serviceLocator()),
  );

  // Blocs
  serviceLocator.registerFactory(
    () => ProfileBloc(getProfileUsecase: serviceLocator()),
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
    () => DocumentRepositoryImpl(
      documentDatasourceInterface: serviceLocator(),
    ),
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

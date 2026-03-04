import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:uit_buddy_mobile/core/config/app_env.dart';
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
import 'package:uit_buddy_mobile/features/onboarding/domain/usecases/signup_complete_usecase.dart';
import 'package:uit_buddy_mobile/features/onboarding/domain/usecases/signup_init_usecase.dart';
import 'package:uit_buddy_mobile/features/onboarding/presentation/blocs/sign_up_info/sign_up_info_bloc.dart';
import 'package:uit_buddy_mobile/features/onboarding/presentation/blocs/sign_up_token/sign_up_token_bloc.dart';

final serviceLocator = GetIt.instance;

Future<void> initDependencies() async {
  await _initAuthDependencies();
  await _initCalendarDependencies();
}

Future<void> _initAuthDependencies() async {
  // Public Dio client (no auth interceptor needed for signup)
  serviceLocator.registerLazySingleton<Dio>(
    () => Dio(
      BaseOptions(
        baseUrl: AppEnv.baseUrl,
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
        headers: {'Content-Type': 'application/json'},
      ),
    ),
    instanceName: 'publicDio',
  );

  // Datasource
  serviceLocator.registerLazySingleton<AuthRemoteDatasource>(
    () => AuthRemoteDatasourceImpl(
      dio: serviceLocator(instanceName: 'publicDio'),
    ),
  );

  // Repository
  serviceLocator.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(authRemoteDatasource: serviceLocator()),
  );

  // Usecases
  serviceLocator.registerLazySingleton(
    () => SignUpInitUsecase(authRepository: serviceLocator()),
  );
  serviceLocator.registerLazySingleton(
    () => SignUpCompleteUsecase(authRepository: serviceLocator()),
  );

  // Blocs
  serviceLocator.registerFactory(
    () => SignUpTokenBloc(signUpInitUsecase: serviceLocator()),
  );
  serviceLocator.registerFactory(
    () => SignUpInfoBloc(signUpCompleteUsecase: serviceLocator()),
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

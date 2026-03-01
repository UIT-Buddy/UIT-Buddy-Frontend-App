import 'package:get_it/get_it.dart';
import 'package:uit_buddy_mobile/features/calendar/data/datasources/calendar_datasource_interface.dart';
import 'package:uit_buddy_mobile/features/calendar/data/datasources/impl/calendar_datasource_impl.dart';
import 'package:uit_buddy_mobile/features/calendar/data/repositories/calendar_repository_impl.dart';
import 'package:uit_buddy_mobile/features/calendar/domain/repositories/calendar_repository.dart';
import 'package:uit_buddy_mobile/features/calendar/domain/usecases/get_deadline_usecase.dart';
import 'package:uit_buddy_mobile/features/calendar/presentation/bloc/calendar_screen/calendar_bloc.dart';
import 'package:uit_buddy_mobile/features/calendar/presentation/bloc/deadline_mode/deadline_bloc.dart';
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

final serviceLocator = GetIt.instance;

Future<void> initDependencies() async {
  await _initCalendarDependencies();
  await _initProfileDependencies();
  await _initNotificationDependencies();
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

import 'package:get_it/get_it.dart';
import 'package:uit_buddy_mobile/features/calendar/data/datasources/calendar_datasource_interface.dart';
import 'package:uit_buddy_mobile/features/calendar/data/datasources/impl/calendar_datasource_impl.dart';
import 'package:uit_buddy_mobile/features/calendar/data/repositories/calendar_repository_impl.dart';
import 'package:uit_buddy_mobile/features/calendar/domain/repositories/calendar_repository.dart';
import 'package:uit_buddy_mobile/features/calendar/domain/usecases/get_deadline_usecase.dart';
import 'package:uit_buddy_mobile/features/calendar/presentation/bloc/calendar_screen/calendar_bloc.dart';
import 'package:uit_buddy_mobile/features/calendar/presentation/bloc/deadline_mode/deadline_bloc.dart';

final serviceLocator = GetIt.instance;

Future<void> initDependencies() async {
  await _initCalendarDependencies();
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

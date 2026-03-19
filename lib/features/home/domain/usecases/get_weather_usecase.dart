import 'package:fpdart/fpdart.dart';
import 'package:uit_buddy_mobile/core/error/failures.dart';
import 'package:uit_buddy_mobile/core/usecase/usecase_interface.dart';
import 'package:uit_buddy_mobile/features/home/domain/entities/weather_entity.dart';
import 'package:uit_buddy_mobile/features/home/domain/repositories/weather_repository.dart';

class GetWeatherUsecase implements UseCase<WeatherEntity, NoParams> {
  GetWeatherUsecase({required WeatherRepository repository})
    : _repository = repository;

  final WeatherRepository _repository;

  @override
  Future<Either<Failure, WeatherEntity>> call(NoParams params) =>
      _repository.getWeather();
}

import 'package:fpdart/fpdart.dart';
import 'package:uit_buddy_mobile/core/error/failures.dart';
import 'package:uit_buddy_mobile/features/home/domain/entities/weather_entity.dart';

abstract interface class WeatherRepository {
  Future<Either<Failure, WeatherEntity>> getWeather();
}

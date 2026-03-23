import 'package:fpdart/fpdart.dart';
import 'package:uit_buddy_mobile/core/error/failures.dart';
import 'package:uit_buddy_mobile/features/home/data/datasources/weather_datasource.dart';
import 'package:uit_buddy_mobile/features/home/data/mapper/weather_mapper.dart';
import 'package:uit_buddy_mobile/features/home/domain/entities/weather_entity.dart';
import 'package:uit_buddy_mobile/features/home/domain/repositories/weather_repository.dart';

class WeatherRepositoryImpl implements WeatherRepository {
  WeatherRepositoryImpl({required WeatherDatasource weatherDatasource})
    : _weatherDatasource = weatherDatasource;

  final WeatherDatasource _weatherDatasource;

  @override
  Future<Either<Failure, WeatherEntity>> getWeather() async {
    try {
      final model = await _weatherDatasource.getWeather();
      return Right(model.toEntity());
    } on Exception catch (e) {
      return Left(Failure.fromException(e));
    }
  }
}

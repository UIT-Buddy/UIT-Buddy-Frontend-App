import 'package:dio/dio.dart';
import 'package:uit_buddy_mobile/core/config/app_env.dart';
import 'package:uit_buddy_mobile/core/config/parameter.dart';
import 'package:uit_buddy_mobile/features/home/data/datasources/weather_datasource.dart';
import 'package:uit_buddy_mobile/features/home/data/models/weather_model.dart';

class WeatherDatasourceImpl implements WeatherDatasource {
  WeatherDatasourceImpl({required Dio dio}) : _dio = dio;

  final Dio _dio;

  @override
  Future<WeatherResponseModel> getWeather() async {
    final response = await _dio.get<Map<String, dynamic>>(
      '/data/3.0/onecall',
      queryParameters: {
        'lat': WeatherParams.lat,
        'lon': WeatherParams.lon,
        'exclude': WeatherParams.exclude,
        'units': WeatherParams.units,
        'lang': WeatherParams.lang,
        'appid': AppEnv.weatherApiKey,
      },
    );
    return WeatherResponseModel.fromJson(response.data!);
  }
}

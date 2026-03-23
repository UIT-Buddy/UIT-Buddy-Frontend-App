import 'package:uit_buddy_mobile/features/home/data/models/weather_model.dart';

abstract interface class WeatherDatasource {
  Future<WeatherResponseModel> getWeather();
}

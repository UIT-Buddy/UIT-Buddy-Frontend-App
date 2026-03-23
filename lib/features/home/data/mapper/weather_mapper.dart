import 'package:uit_buddy_mobile/features/home/data/models/weather_model.dart';
import 'package:uit_buddy_mobile/features/home/domain/entities/weather_entity.dart';

extension WeatherConditionModelMapper on WeatherConditionModel {
  WeatherConditionEntity toEntity() => WeatherConditionEntity(
    id: id,
    main: main,
    description: description,
    icon: icon,
  );
}

extension CurrentWeatherModelMapper on CurrentWeatherModel {
  CurrentWeatherEntity toEntity() => CurrentWeatherEntity(
    dt: dt,
    temp: temp,
    feelsLike: feelsLike,
    humidity: humidity,
    uvi: uvi,
    visibility: visibility,
    windSpeed: windSpeed,
    clouds: clouds,
    weather: weather.map((w) => w.toEntity()).toList(),
  );
}

extension HourlyWeatherModelMapper on HourlyWeatherModel {
  HourlyWeatherEntity toEntity() => HourlyWeatherEntity(
    dt: dt,
    temp: temp,
    feelsLike: feelsLike,
    weather: weather.map((w) => w.toEntity()).toList(),
    pop: pop,
  );
}

extension DailyTempModelMapper on DailyTempModel {
  DailyTempEntity toEntity() =>
      DailyTempEntity(day: day, min: min, max: max, night: night);
}

extension DailyWeatherModelMapper on DailyWeatherModel {
  DailyWeatherEntity toEntity() => DailyWeatherEntity(
    dt: dt,
    temp: temp.toEntity(),
    humidity: humidity,
    windSpeed: windSpeed,
    weather: weather.map((w) => w.toEntity()).toList(),
    uvi: uvi,
    pop: pop,
    summary: summary,
  );
}

extension WeatherResponseModelMapper on WeatherResponseModel {
  WeatherEntity toEntity() => WeatherEntity(
    timezone: timezone,
    current: current.toEntity(),
    hourly: hourly.map((h) => h.toEntity()).toList(),
    daily: daily.map((d) => d.toEntity()).toList(),
  );
}

import 'package:equatable/equatable.dart';

class WeatherConditionEntity extends Equatable {
  const WeatherConditionEntity({
    required this.id,
    required this.main,
    required this.description,
    required this.icon,
  });

  final int id;
  final String main;
  final String description;

  /// OpenWeatherMap icon code, e.g. "01d", "02n"
  final String icon;

  @override
  List<Object?> get props => [id, main, description, icon];
}

class CurrentWeatherEntity extends Equatable {
  const CurrentWeatherEntity({
    required this.dt,
    required this.temp,
    required this.feelsLike,
    required this.humidity,
    required this.uvi,
    required this.visibility,
    required this.windSpeed,
    required this.clouds,
    required this.weather,
  });

  final int dt;
  final double temp;
  final double feelsLike;
  final int humidity;
  final double uvi;

  /// Visibility in metres
  final int visibility;

  final double windSpeed;

  /// Cloud cover in percent (0–100)
  final int clouds;

  final List<WeatherConditionEntity> weather;

  @override
  List<Object?> get props => [
    dt,
    temp,
    feelsLike,
    humidity,
    uvi,
    visibility,
    windSpeed,
    clouds,
    weather,
  ];
}

class HourlyWeatherEntity extends Equatable {
  const HourlyWeatherEntity({
    required this.dt,
    required this.temp,
    required this.feelsLike,
    required this.weather,
    required this.pop,
  });

  final int dt;
  final double temp;
  final double feelsLike;
  final List<WeatherConditionEntity> weather;

  /// Probability of precipitation [0.0 – 1.0]
  final double pop;

  @override
  List<Object?> get props => [dt, temp, feelsLike, weather, pop];
}

class DailyTempEntity extends Equatable {
  const DailyTempEntity({
    required this.day,
    required this.min,
    required this.max,
    required this.night,
  });

  final double day;
  final double min;
  final double max;
  final double night;

  @override
  List<Object?> get props => [day, min, max, night];
}

class DailyWeatherEntity extends Equatable {
  const DailyWeatherEntity({
    required this.dt,
    required this.temp,
    required this.humidity,
    required this.windSpeed,
    required this.weather,
    required this.uvi,
    required this.pop,
    required this.summary,
  });

  final int dt;
  final DailyTempEntity temp;
  final int humidity;
  final double windSpeed;
  final List<WeatherConditionEntity> weather;
  final double uvi;
  final double pop;
  final String summary;

  @override
  List<Object?> get props => [
    dt,
    temp,
    humidity,
    windSpeed,
    weather,
    uvi,
    pop,
    summary,
  ];
}

class WeatherEntity extends Equatable {
  const WeatherEntity({
    required this.timezone,
    required this.current,
    required this.hourly,
    required this.daily,
  });

  final String timezone;
  final CurrentWeatherEntity current;
  final List<HourlyWeatherEntity> hourly;
  final List<DailyWeatherEntity> daily;

  @override
  List<Object?> get props => [timezone, current, hourly, daily];
}

// ignore_for_file: invalid_annotation_target
import 'package:freezed_annotation/freezed_annotation.dart';

part 'weather_model.freezed.dart';
part 'weather_model.g.dart';

// ---------------------------------------------------------------------------
// Helper — handles JSON integers where doubles are expected (e.g. pop: 0)
// ---------------------------------------------------------------------------

double _numToDouble(dynamic value) => (value as num).toDouble();

// ---------------------------------------------------------------------------
// WeatherConditionModel
// ---------------------------------------------------------------------------

@freezed
abstract class WeatherConditionModel with _$WeatherConditionModel {
  const factory WeatherConditionModel({
    required int id,
    required String main,
    required String description,
    required String icon,
  }) = _WeatherConditionModel;

  factory WeatherConditionModel.fromJson(Map<String, dynamic> json) =>
      _$WeatherConditionModelFromJson(json);
}

// ---------------------------------------------------------------------------
// CurrentWeatherModel
// ---------------------------------------------------------------------------

@freezed
abstract class CurrentWeatherModel with _$CurrentWeatherModel {
  const factory CurrentWeatherModel({
    required int dt,
    required double temp,
    @JsonKey(name: 'feels_like') required double feelsLike,
    required int humidity,
    @JsonKey(fromJson: _numToDouble) required double uvi,
    required int visibility,
    @JsonKey(name: 'wind_speed') required double windSpeed,
    required int clouds,
    required List<WeatherConditionModel> weather,
  }) = _CurrentWeatherModel;

  factory CurrentWeatherModel.fromJson(Map<String, dynamic> json) =>
      _$CurrentWeatherModelFromJson(json);
}

// ---------------------------------------------------------------------------
// HourlyWeatherModel
// ---------------------------------------------------------------------------

@freezed
abstract class HourlyWeatherModel with _$HourlyWeatherModel {
  const factory HourlyWeatherModel({
    required int dt,
    required double temp,
    @JsonKey(name: 'feels_like') required double feelsLike,
    required List<WeatherConditionModel> weather,
    @JsonKey(fromJson: _numToDouble) required double pop,
  }) = _HourlyWeatherModel;

  factory HourlyWeatherModel.fromJson(Map<String, dynamic> json) =>
      _$HourlyWeatherModelFromJson(json);
}

// ---------------------------------------------------------------------------
// DailyTempModel
// ---------------------------------------------------------------------------

@freezed
abstract class DailyTempModel with _$DailyTempModel {
  const factory DailyTempModel({
    required double day,
    required double min,
    required double max,
    required double night,
  }) = _DailyTempModel;

  factory DailyTempModel.fromJson(Map<String, dynamic> json) =>
      _$DailyTempModelFromJson(json);
}

// ---------------------------------------------------------------------------
// DailyWeatherModel
// ---------------------------------------------------------------------------

@freezed
abstract class DailyWeatherModel with _$DailyWeatherModel {
  const factory DailyWeatherModel({
    required int dt,
    required DailyTempModel temp,
    required int humidity,
    @JsonKey(name: 'wind_speed') required double windSpeed,
    required List<WeatherConditionModel> weather,
    @JsonKey(fromJson: _numToDouble) required double uvi,
    @JsonKey(fromJson: _numToDouble) required double pop,
    required String summary,
  }) = _DailyWeatherModel;

  factory DailyWeatherModel.fromJson(Map<String, dynamic> json) =>
      _$DailyWeatherModelFromJson(json);
}

// ---------------------------------------------------------------------------
// WeatherResponseModel  (root)
// ---------------------------------------------------------------------------

@freezed
abstract class WeatherResponseModel with _$WeatherResponseModel {
  const factory WeatherResponseModel({
    required String timezone,
    required CurrentWeatherModel current,
    required List<HourlyWeatherModel> hourly,
    required List<DailyWeatherModel> daily,
  }) = _WeatherResponseModel;

  factory WeatherResponseModel.fromJson(Map<String, dynamic> json) =>
      _$WeatherResponseModelFromJson(json);
}

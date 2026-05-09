import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:uit_buddy_mobile/features/home/domain/entities/weather_entity.dart';

part 'weather_state.freezed.dart';

enum WeatherStatus { initial, loading, success, failure }

@freezed
abstract class WeatherState with _$WeatherState {
  const factory WeatherState({
    @Default(WeatherStatus.initial) WeatherStatus status,
    WeatherEntity? weather,
    String? errorMessage,
  }) = _WeatherState;
}

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uit_buddy_mobile/core/usecase/usecase_interface.dart';
import 'package:uit_buddy_mobile/features/home/domain/usecases/get_weather_usecase.dart';
import 'package:uit_buddy_mobile/features/home/presentation/bloc/weather_event.dart';
import 'package:uit_buddy_mobile/features/home/presentation/bloc/weather_state.dart';

class WeatherBloc extends Bloc<WeatherEvent, WeatherState> {
  WeatherBloc({required GetWeatherUsecase getWeatherUsecase})
    : _getWeatherUsecase = getWeatherUsecase,
      super(const WeatherState()) {
    on<WeatherFetched>(_onWeatherFetched);
  }

  final GetWeatherUsecase _getWeatherUsecase;

  Future<void> _onWeatherFetched(
    WeatherFetched event,
    Emitter<WeatherState> emit,
  ) async {
    emit(state.copyWith(status: WeatherStatus.loading));

    final result = await _getWeatherUsecase(const NoParams());

    result.fold(
      (failure) => emit(
        state.copyWith(
          status: WeatherStatus.failure,
          errorMessage: failure.message,
        ),
      ),
      (weather) =>
          emit(state.copyWith(status: WeatherStatus.success, weather: weather)),
    );
  }
}

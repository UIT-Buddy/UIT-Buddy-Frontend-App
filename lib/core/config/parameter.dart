class WeatherParams {
  /// Latitude of UIT campus (Thu Duc, Ho Chi Minh City)
  static const double lat = 10.8700089;

  /// Longitude of UIT campus
  static const double lon = 106.8030541;

  /// OpenWeatherMap units — metric returns °C, m/s
  static const String units = 'metric';

  /// Response language
  static const String lang = 'eng';

  /// Exclude parts of the response (comma-separated)
  static const String exclude = 'minutely';

  /// OpenWeatherMap One Call API base URL
  static const String baseUrl = 'https://api.openweathermap.org';
}

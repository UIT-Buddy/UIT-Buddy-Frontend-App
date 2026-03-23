class AppEnv {
  static const String baseUrl = String.fromEnvironment(
    'BASE_URL',
    defaultValue: 'http://103.163.215.75:8080',
  );

  static const String weatherApiKey = String.fromEnvironment('WEATHER_API_KEY');
}

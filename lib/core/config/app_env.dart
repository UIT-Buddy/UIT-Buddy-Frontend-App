class AppEnv {
  static const String baseUrl = String.fromEnvironment(
    'BASE_URL',
    defaultValue: 'http://52.64.199.49:8080',
  );

  static const String weatherApiKey = String.fromEnvironment('WEATHER_API_KEY');
}

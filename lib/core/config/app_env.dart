class AppEnv {
  static const String baseUrl = String.fromEnvironment(
    'BASE_URL',
    defaultValue: 'http://52.64.199.49:8080',
  );

  static const String weatherApiKey = String.fromEnvironment('WEATHER_API_KEY');
  static const String cometChatApiUrl = String.fromEnvironment(
    'COMETCHAT_API_URL',
  );
  static const String cometChatAppId = String.fromEnvironment(
    'COMETCHAT_APP_ID',
  );
  static const String cometChatRegion = String.fromEnvironment(
    'COMETCHAT_REGION',
  );
  static const String cometChatProviderId = String.fromEnvironment(
    'COMETCHAT_PROVIDER_ID',
  );
}

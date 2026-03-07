class AppEnv {
  static const String baseUrl = String.fromEnvironment(
    'BASE_URL',
    defaultValue: 'https://maurice-baccate-kookily.ngrok-free.dev',
  );
}

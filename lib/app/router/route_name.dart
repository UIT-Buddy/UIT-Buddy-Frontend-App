class RouteName {
  static const String home = '/home';
  static const String signIn = '/sign-in';
  static const String signUpToken = '/sign-up/token';
  static const String signUpInfo =
      '/sign-up/info/:studentId/:studentName/:signupToken';
  static String buildSignUpInfoPath(
    String studentId,
    String studentName,
    String signupToken,
  ) =>
      '/sign-up/info/$studentId/${Uri.encodeComponent(studentName)}/${Uri.encodeComponent(signupToken)}';
  static const String resetPassword = '/reset-password';
  static const String welcome = '/welcome';
  static const String otp = '/otp';
  static const String calendar = '/calendar';
  static const String social = '/social';
  static const String storage = '/storage';
  static const String profile = '/profile';
}

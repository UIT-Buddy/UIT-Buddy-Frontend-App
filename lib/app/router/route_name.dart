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
  static const String resetPassword = '/reset-password/:mssv/:otpCode';
  static String buildResetPasswordPath(String mssv, String otpCode) =>
      '/reset-password/${Uri.encodeComponent(mssv)}/${Uri.encodeComponent(otpCode)}';
  static const String welcome = '/welcome';
  static const String otp = '/otp';
  static const String calendar = '/calendar';
  static const String social = '/social';
  static const String storage = '/storage';
  static const String profile = '/profile';
  static const String notification = '/notification';
  static const String tasks = '/tasks';
  static const String taskDetail = '/task-detail';
  static const String addEditTask = '/add-edit-task';
  static const String yourInfo = '/your-info';
  static const String editYourInfo = '/edit-your-info';
  static const String groupsJoined = '/groups-joined';
  static const String yourPosts = '/your-posts';
  static const String academicDetail = '/academic-detail';
  static const String semesterDetail = '/semester-detail';
  static const String settings = '/settings';
  static const String note = '/note';
  static const String website = '/website';
  static const String weather = '/weather';
  static const String chat = '/chat';
  static const String chatConversation = '/chat/conversation';
  static const String chatSearch = '/chat/search';
  static const String chatContacts = '/chat/contacts';
}

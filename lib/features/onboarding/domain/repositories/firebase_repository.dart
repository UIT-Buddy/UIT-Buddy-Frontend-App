abstract interface class FirebaseRepository {
  Future<bool> requestPermission();
  Future<String?> getFcmToken();
  Stream<String?> onTokenRefresh();
}

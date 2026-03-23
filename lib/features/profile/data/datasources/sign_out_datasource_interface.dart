abstract interface class SignOutDatasource {
  Future<void> signOut({required String refreshToken});
}

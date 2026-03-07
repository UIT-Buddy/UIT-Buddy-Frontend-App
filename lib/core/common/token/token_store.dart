abstract interface class TokenStore {
  Future<String> getAccessToken();
  Future<String> getRefreshToken();
  Future<void> saveAccessToken(String accessToken);
  Future<void> saveRefreshToken(String refreshToken, {bool rememberMe = false});
  Future<void> deleteAccessToken();
  Future<void> deleteRefreshToken();
  Future<void> replaceRefreshToken(String newRefreshToken);
}

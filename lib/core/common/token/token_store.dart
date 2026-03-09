abstract interface class TokenStore {
  Future<String> getAccessToken();
  Future<String> getRefreshToken();
  Future<void> saveAccessToken(String accessToken);
  Future<void> saveRefreshToken(String refreshToken, {bool rememberMe = false});
  Future<void> deleteAccessToken();
  Future<void> deleteRefreshToken();
  Future<void> replaceRefreshToken(String newRefreshToken);

  /// Loads persisted tokens from secure storage into memory. Call once on startup.
  Future<void> loadPersistedTokens();

  /// Returns true if a refresh token is currently available (in memory or secure storage).
  bool get hasSession;
}

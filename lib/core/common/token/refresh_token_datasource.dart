abstract interface class RefreshTokenDataSource {
  Future<(String? accessToken, String? refreshToken)> refreshTokens(
    String refreshToken,
  );
}

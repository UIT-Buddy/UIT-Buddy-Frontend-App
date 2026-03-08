import 'package:uit_buddy_mobile/core/common/token/token_store.dart';
import 'package:uit_buddy_mobile/core/storages/secure_storage.dart';

class TokenStoreImpl implements TokenStore {
  TokenStoreImpl({required SecureStore secureStore})
    : _secureStore = secureStore;

  static const _accessTokenKey = 'access_token';
  static const _refreshTokenKey = 'refresh_token';

  final SecureStore _secureStore;

  String _accessToken = '';
  String _refreshToken = '';

  @override
  bool get hasSession => _refreshToken.isNotEmpty;

  @override
  Future<void> loadPersistedTokens() async {
    final persisted = await _secureStore.get<String>(_refreshTokenKey);
    if (persisted != null && persisted.isNotEmpty) {
      _refreshToken = persisted;
    }
  }

  @override
  Future<String> getAccessToken() async => _accessToken;

  @override
  Future<String> getRefreshToken() async {
    if (_refreshToken.isNotEmpty) return _refreshToken;
    return await _secureStore.get<String>(_refreshTokenKey) ?? '';
  }

  @override
  Future<void> saveAccessToken(String accessToken) async {
    _accessToken = accessToken;
  }

  @override
  Future<void> saveRefreshToken(
    String refreshToken, {
    bool rememberMe = false,
  }) async {
    _refreshToken = refreshToken;
    // Always persist to secure storage so the session survives app restarts.
    await _secureStore.set<String>(_refreshTokenKey, refreshToken);
  }

  @override
  Future<void> deleteAccessToken() async {
    _accessToken = '';
    await _secureStore.remove(_accessTokenKey);
  }

  @override
  Future<void> deleteRefreshToken() async {
    _refreshToken = '';
    await _secureStore.remove(_refreshTokenKey);
  }

  @override
  Future<void> replaceRefreshToken(String newRefreshToken) async {
    _refreshToken = newRefreshToken;
    await _secureStore.set<String>(_refreshTokenKey, newRefreshToken);
  }
}

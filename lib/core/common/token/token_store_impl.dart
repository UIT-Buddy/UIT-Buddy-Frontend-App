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
  Future<String> getAccessToken() async => _accessToken;

  @override
  Future<String> getRefreshToken() async {
    if (_refreshToken.isNotEmpty) return _refreshToken;
    // rememberMe=true: was persisted in secure storage
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
    if (rememberMe) {
      await _secureStore.set<String>(_refreshTokenKey, refreshToken);
    }
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
    final wasPersisted =
        await _secureStore.get<String>(_refreshTokenKey) != null;
    _refreshToken = newRefreshToken;
    if (wasPersisted) {
      await _secureStore.set<String>(_refreshTokenKey, newRefreshToken);
    }
  }
}

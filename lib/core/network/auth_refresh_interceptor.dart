import 'dart:async';
import 'package:dio/dio.dart';
import 'package:uit_buddy_mobile/core/common/token/refresh_token_datasource.dart';
import 'package:uit_buddy_mobile/core/common/token/token_store.dart';
import 'package:uit_buddy_mobile/core/error/authentication_exception.dart';

class AuthRefreshInterceptor extends Interceptor {
  AuthRefreshInterceptor({
    required Dio dio,
    required TokenStore tokenStore,
    required RefreshTokenDataSource refreshDataSource,
    this.shouldAttachToken,
    this.isRefreshRequest,
  }) : _dio = dio,
       _tokenStore = tokenStore,
       _refreshDs = refreshDataSource;

  final Dio _dio;
  final TokenStore _tokenStore;
  final RefreshTokenDataSource _refreshDs;

  final bool Function(RequestOptions options)? shouldAttachToken;
  final bool Function(RequestOptions options)? isRefreshRequest;

  bool _refreshing = false;
  Completer<void>? _refreshCompleter;

  static const _retryMarkKey = '__retried__';

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    try {
      if (shouldAttachToken != null && !shouldAttachToken!(options)) {
        return handler.next(options);
      }

      if (isRefreshRequest != null && isRefreshRequest!(options)) {
        return handler.next(options);
      }

      final accessToken = await _tokenStore.getAccessToken();
      if (accessToken.isNotEmpty) {
        options.headers['Authorization'] = accessToken;
      }
      // ignore: avoid_catches_without_on_clauses
    } catch (_) {}

    handler.next(options);
  }

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    final status = err.response?.statusCode;

    if (status != 401) return handler.next(err);

    final req = err.requestOptions;
    // Ignore public paths
    if (shouldAttachToken != null && !shouldAttachToken!(req)) {
      return handler.next(err);
    }

    // Ignore refresh request
    if (isRefreshRequest != null && isRefreshRequest!(req)) {
      return handler.next(err);
    }

    // Prevent infinite retry
    final alreadyRetried = (req.extra[_retryMarkKey] == true);
    if (alreadyRetried) return handler.next(err);
    try {
      await _ensureRefreshedTokens();

      // Get new access token and retry request
      final newAccessToken = await _tokenStore.getAccessToken();

      final retryOptions = _cloneOptionsForRetry(req, newAccessToken);
      final response = await _dio.fetch<dynamic>(retryOptions);

      return handler.resolve(response);
      // ignore: avoid_catches_without_on_clauses
    } catch (_) {
      // Refresh fail -> delete token and throw authentication exception
      try {
        await _tokenStore.deleteAccessToken();
        await _tokenStore.deleteRefreshToken();
      } on Exception catch (_) {}

      // Create a new DioException with AuthenticationException as error
      final authError = DioException(
        requestOptions: err.requestOptions,
        response: err.response,
        error: AuthenticationException('Session expired. Please login again.'),
      );
      return handler.next(authError);
    }
  }

  Future<void> _ensureRefreshedTokens() async {
    // If already refreshing -> wait
    if (_refreshing) {
      await (_refreshCompleter?.future ?? Future<void>.value());
      return;
    }

    _refreshing = true;
    _refreshCompleter = Completer<void>();

    try {
      final refreshToken = await _tokenStore.getRefreshToken();
      if (refreshToken.isEmpty) {
        throw StateError('No refresh token');
      }

      final (accessToken, newRefreshToken) = await _refreshDs.refreshTokens(
        refreshToken,
      );

      if (accessToken == null || newRefreshToken == null) {
        throw StateError('Refresh token failed');
      }
      await _tokenStore.saveAccessToken(accessToken);
      await _tokenStore.replaceRefreshToken(newRefreshToken);

      _refreshCompleter?.complete();
    } catch (e) {
      if (!(_refreshCompleter?.isCompleted ?? true)) {
        _refreshCompleter!.complete();
      }
      rethrow;
    } finally {
      _refreshing = false;
    }
  }

  RequestOptions _cloneOptionsForRetry(RequestOptions req, String accessToken) {
    final headers = Map<String, dynamic>.from(req.headers);
    if (accessToken.isNotEmpty) {
      headers['Authorization'] = accessToken;
    }

    final extra = Map<String, dynamic>.from(req.extra);
    extra[_retryMarkKey] = true;

    return RequestOptions(
      path: req.path,
      method: req.method,
      baseUrl: req.baseUrl,
      data: req.data,
      queryParameters: req.queryParameters,
      headers: headers,
      extra: extra,
      contentType: req.contentType,
      responseType: req.responseType,
      followRedirects: req.followRedirects,
      listFormat: req.listFormat,
      maxRedirects: req.maxRedirects,
      persistentConnection: req.persistentConnection,
      receiveDataWhenStatusError: req.receiveDataWhenStatusError,
      receiveTimeout: req.receiveTimeout,
      requestEncoder: req.requestEncoder,
      responseDecoder: req.responseDecoder,
      sendTimeout: req.sendTimeout,
      validateStatus: req.validateStatus,
      onReceiveProgress: req.onReceiveProgress,
      onSendProgress: req.onSendProgress,
      cancelToken: req.cancelToken,
    );
  }
}

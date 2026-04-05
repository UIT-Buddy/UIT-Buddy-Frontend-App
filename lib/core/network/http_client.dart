import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:uit_buddy_mobile/core/common/token/refresh_token_datasource.dart';
import 'package:uit_buddy_mobile/core/common/token/token_store.dart';
import 'package:uit_buddy_mobile/core/network/auth_refresh_interceptor.dart';

class HttpClient {
  HttpClient({
    required TokenStore tokenStore,
    required RefreshTokenDataSource refreshTokenDataSource,
  }) : _tokenStore = tokenStore,
       _refreshTokenDataSource = refreshTokenDataSource;
  final TokenStore _tokenStore;
  final RefreshTokenDataSource _refreshTokenDataSource;
  Dio createDioClient(String baseUrl, {void Function()? onSessionExpired}) {
    final dio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
        connectTimeout: const Duration(seconds: 90),
        receiveTimeout: const Duration(seconds: 90),
        headers: {
          'Content-Type': 'application/json',
          'ngrok-skip-browser-warning': 'true',
        },
      ),
    );

    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          log(
            'REQUEST\n'
            'Method: ${options.method}\n'
            'URL: ${options.baseUrl}${options.path}\n'
            'Headers: ${options.headers}\n'
            'Body: ${options.data}',
            name: 'HttpClient',
          );
          handler.next(options);
        },
        onResponse: (response, handler) {
          log(
            'RESPONSE\n'
            'Status: ${response.statusCode}\n'
            'URL: ${response.requestOptions.uri}\n'
            'Body: ${response.data}',
            name: 'HttpClient',
          );
          handler.next(response);
        },
        onError: (error, handler) {
          final uri = error.requestOptions.uri;
          final method = error.requestOptions.method;
          final statusCode = error.response?.statusCode;
          final errorType = error.type.name;
          final responseData = error.response?.data;

          log(
            'HTTP ERROR\n'
            'Method: $method\n'
            'URL: $uri\n'
            'Status Code: $statusCode\n'
            'Error Type: $errorType\n'
            'Error Message: ${error.message}\n'
            'Response Data: $responseData',
            name: 'HttpClient',
            error: error,
            stackTrace: error.stackTrace,
          );
          handler.next(error);
        },
      ),
    );
    dio.interceptors.add(
      AuthRefreshInterceptor(
        dio: dio,
        tokenStore: _tokenStore,
        refreshDataSource: _refreshTokenDataSource,
        shouldAttachToken: _shouldAttachToken,
        onSessionExpired: onSessionExpired,
      ),
    );

    return dio;
  }

  final List<String> publicPaths = [
    '/api/auth/signin',
    '/api/auth/signup/init',
    '/api/auth/signup/complete',
    '/api/auth/forget-password',
    '/api/auth/reset-password',
    '/api/auth/refresh-token',
  ];
  bool _shouldAttachToken(RequestOptions options) =>
      !publicPaths.contains(options.path);
}

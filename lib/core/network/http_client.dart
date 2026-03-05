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
  Dio createDioClient(String baseUrl) {
    final dio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
        headers: {
          'Content-Type': 'application/json',
          'ngrok-skip-browser-warning': 'true',
        },
      ),
    );

    dio.interceptors.add(
      LogInterceptor(
        requestBody: true,
        responseHeader: false,
        responseBody: true,
        logPrint: (o) => log('$o', name: 'HttpClient'),
      ),
    );
    dio.interceptors.add(
      AuthRefreshInterceptor(
        dio: dio,
        tokenStore: _tokenStore,
        refreshDataSource: _refreshTokenDataSource,
        shouldAttachToken: _shouldAttachToken,
      ),
    );

    return dio;
  }

  final List<String> publicPaths = [
    '/public/auth/login',
    '/public/auth/register',
    '/public/auth/password/forgot',
    '/public/auth/password/reset',
    '/public/auth/refresh',
  ];
  bool _shouldAttachToken(RequestOptions options) =>
      !publicPaths.contains(options.path);
}

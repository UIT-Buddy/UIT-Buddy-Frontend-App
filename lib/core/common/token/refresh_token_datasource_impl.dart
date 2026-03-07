import 'package:dio/dio.dart';
import 'package:uit_buddy_mobile/core/common/token/refresh_token_datasource.dart';
import 'package:uit_buddy_mobile/core/network/api/api_response.dart';
import 'package:uit_buddy_mobile/features/onboarding/data/models/signup_complete_response_model.dart';

class RefreshTokenDataSourceImpl implements RefreshTokenDataSource {
  RefreshTokenDataSourceImpl({required Dio dio}) : _dio = dio;

  final Dio _dio;

  @override
  Future<(String? accessToken, String? refreshToken)> refreshTokens(
    String refreshToken,
  ) async {
    final response = await _dio.post<Map<String, dynamic>>(
      '/api/auth/refresh-token',
      options: Options(headers: {'X-Refresh-Token': refreshToken}),
    );

    final apiResponse = apiResponseObjectFromJson(
      response.data!,
      SignUpCompleteResponseModel.fromJson,
    );

    return (apiResponse.data?.accessToken, apiResponse.data?.refreshToken);
  }
}

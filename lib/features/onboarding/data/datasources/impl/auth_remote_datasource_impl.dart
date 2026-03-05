import 'package:dio/dio.dart';
import 'package:uit_buddy_mobile/core/network/api/api_response.dart';
import 'package:uit_buddy_mobile/features/onboarding/data/datasources/auth_remote_datasource.dart';
import 'package:uit_buddy_mobile/features/onboarding/data/models/moodle_token_model.dart';
import 'package:uit_buddy_mobile/features/onboarding/data/models/signup_complete_request_model.dart';
import 'package:uit_buddy_mobile/features/onboarding/data/models/signup_complete_response_model.dart';
import 'package:uit_buddy_mobile/features/onboarding/data/models/signup_init_request_model.dart';

class AuthRemoteDatasourceImpl implements AuthRemoteDatasource {
  AuthRemoteDatasourceImpl({required Dio dio}) : _dio = dio;

  final Dio _dio;

  @override
  Future<ApiResponse<MoodleTokenModel>> signUpInit({
    required String wstoken,
  }) async {
    final response = await _dio.post<Map<String, dynamic>>(
      '/api/auth/signup/init',
      data: SignUpInitRequestModel(wstoken: wstoken).toJson(),
    );

    return apiResponseObjectFromJson(response.data!, MoodleTokenModel.fromJson);
  }

  @override
  Future<ApiResponse<SignUpCompleteResponseModel>> signUpComplete({
    required String signupToken,
    required String mssv,
    required String password,
    required String confirmPassword,
    String fcmToken = '',
  }) async {
    final response = await _dio.post<Map<String, dynamic>>(
      '/api/auth/signup/complete',
      data: SignUpCompleteRequestModel(
        signupToken: signupToken,
        mssv: mssv,
        password: password,
        confirmPassword: confirmPassword,
        fcmToken: fcmToken,
      ).toJson(),
    );

    return apiResponseObjectFromJson(
      response.data!,
      SignUpCompleteResponseModel.fromJson,
    );
  }
}

import 'package:dio/dio.dart';
import 'package:uit_buddy_mobile/core/network/api/api_response.dart';
import 'package:uit_buddy_mobile/features/session/data/models/user_model.dart';
import 'package:uit_buddy_mobile/features/social/data/datasources/user_profile_datasource_interface.dart';

class UserProfileDatasourceImpl implements UserProfileDatasourceInterface {
  UserProfileDatasourceImpl({required Dio dio}) : _dio = dio;

  final Dio _dio;

  @override
  Future<ApiResponse<UserModel>> getUserProfile(String mssv) async {
    final response = await _dio.get<Map<String, dynamic>>('/api/user/$mssv');
    return apiResponseObjectFromJson(response.data!, UserModel.fromJson);
  }
}

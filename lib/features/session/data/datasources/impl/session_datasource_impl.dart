import 'package:dio/dio.dart';
import 'package:uit_buddy_mobile/core/network/api/api_response.dart';
import 'package:uit_buddy_mobile/features/session/data/datasources/session_datasource_interface.dart';
import 'package:uit_buddy_mobile/features/session/data/models/user_model.dart';

class SessionDatasourceImpl implements SessionDatasourceInterface {
  SessionDatasourceImpl({required Dio dio}) : _dio = dio;

  final Dio _dio;

  @override
  Future<ApiResponse<UserModel>> getCurrentUser() async {
    final response = await _dio.get<Map<String, dynamic>>('/api/user/me');
    return apiResponseObjectFromJson(response.data!, UserModel.fromJson);
  }
}

import 'package:dio/dio.dart';
import 'package:uit_buddy_mobile/core/network/api/api_response.dart';
import 'package:uit_buddy_mobile/features/social/data/datasources/user_profile_datasource_interface.dart';
import 'package:uit_buddy_mobile/features/social/data/models/other_people_model.dart';
import 'package:uit_buddy_mobile/features/social/domain/repositories/user_profile_repository.dart';

class UserProfileDatasourceImpl implements UserProfileDatasourceInterface {
  UserProfileDatasourceImpl({required Dio dio}) : _dio = dio;

  final Dio _dio;

  @override
  Future<ApiResponse<OtherPeopleModel>> getUserProfile(String mssv) async {
    final response = await _dio.get<Map<String, dynamic>>('/api/user/$mssv');
    return apiResponseObjectFromJson(response.data!, OtherPeopleModel.fromJson);
  }

  @override
  Future<ApiResponse<void>> toggleFriendRequest(String receiverMssv) async {
    final response = await _dio.post<Map<String, dynamic>>(
      '/api/friends/requests',
      data: {'receiverMssv': receiverMssv},
    );
    return apiResponseVoidFromJson(response.data!);
  }

  @override
  Future<ApiResponse<void>> respondToFriendRequest({
    required String senderMssv,
    required FriendRequestResponseAction action,
  }) async {
    final response = await _dio.put<Map<String, dynamic>>(
      '/api/friends/requests/$senderMssv',
      data: {'action': action.apiValue},
    );
    return apiResponseVoidFromJson(response.data!);
  }

  @override
  Future<ApiResponse<void>> unfriend(String friendMssv) async {
    final response = await _dio.delete<Map<String, dynamic>>(
      '/api/friends/$friendMssv',
    );
    return apiResponseVoidFromJson(response.data!);
  }
}

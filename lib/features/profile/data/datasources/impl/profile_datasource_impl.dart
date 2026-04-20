import 'package:dio/dio.dart';
import 'package:uit_buddy_mobile/core/network/api/api_response.dart';
import 'package:uit_buddy_mobile/features/profile/data/datasources/profile_datasource_interface.dart';
import 'package:uit_buddy_mobile/features/profile/data/models/profile_model.dart';

class ProfileInfoDatasourceImpl implements ProfileDatasourceInterface {
  ProfileInfoDatasourceImpl({required Dio dio}) : _dio = dio;

  final Dio _dio;

  @override
  Future<ApiResponse<ProfileModel>> getProfile() async {
    final response = await _getMeResponse();
    return apiResponseObjectFromJson(response.data!, ProfileModel.fromMeJson);

    // Mocked API response kept for fallback/local dev reference.
    // return ApiResponse<ProfileModel>(
    //   data: ProfileModel(
    //     mssv: '23520540',
    //     fullName: 'Minh Hoàng',
    //     email: '23520540@gm.uit.edu.vn',
    //     avatarUrl: 'assets/images/sample/f1.jpg',
    //     bio: 'UIT student passionate about mobile development and UI/UX design.',
    //     coverUrl: 'assets/images/sample/xp.jpg',
    //     homeClassCode: 'KTPM2023.1',
    //     friendStatus: 'NONE',
    //     stats: const ProfileStatsModel(
    //       currentGpa: 8.2,
    //       gpaOn4Scale: 3.2,
    //       accumulatedCredits: 103,
    //       totalCredits: 130,
    //       posts: 15,
    //       comments: 130,
    //     ),
    //   ),
    //   message: 'Profile fetched successfully.',
    //   statusCode: 200,
    // );
  }

  @override
  Future<ApiResponse<String>> uploadUserCoverPicture({
    required List<int> fileBytes,
    required String fileName,
  }) async {
    final formData = FormData.fromMap({
      'file': MultipartFile.fromBytes(
        fileBytes,
        filename: fileName.isEmpty ? 'cover.jpg' : fileName,
      ),
    });

    final response = await _dio.post<Map<String, dynamic>>(
      '/api/user/cover',
      data: formData,
      options: Options(contentType: 'multipart/form-data'),
    );

    return apiResponseStringFromJson(response.data!);
  }

  Future<Response<Map<String, dynamic>>> _getMeResponse() async {
    return await _dio.get<Map<String, dynamic>>('/api/user/me');
  }
}

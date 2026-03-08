import 'package:uit_buddy_mobile/core/network/api/api_response.dart';
import 'package:uit_buddy_mobile/features/profile/data/datasources/profile_datasource_interface.dart';
import 'package:uit_buddy_mobile/features/profile/data/models/profile_model.dart';

class ProfileInfoDatasourceImpl implements ProfileDatasourceInterface {
  @override
  Future<ApiResponse<ProfileModel>> getProfile({required String email}) async {
    try {
      await Future.delayed(const Duration(milliseconds: 500));

      // Mocked API response
      final apiResponse = ApiResponse<ProfileModel>(
        data: ProfileModel(
          mssv: '23520540',
          fullName: 'Minh Hoàng',
          email: '23520540@gm.uit.edu.vn',
          avatarUrl: 'assets/images/sample/f1.jpg',
          coverUrl: 'assets/images/sample/xp.jpg',
          stats: ProfileStatsModel(
            currentGpa: 8.2,
            gpaOn4Scale: 3.2,
            accumulatedCredits: 103,
            totalCredits: 130,
            posts: 15,
            comments: 130,
          ),
        ),
        message: 'Profile fetched successfully.',
        statusCode: 200,
      );

      return apiResponse;
    } catch (e) {
      return ApiResponse<ProfileModel>(
        data: null,
        message: 'Failed to fetch profile.',
        statusCode: 500,
      );
    }
  }
}

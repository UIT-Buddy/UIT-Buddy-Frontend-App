import 'package:uit_buddy_mobile/core/network/api/api_response.dart';
import 'package:uit_buddy_mobile/features/profile/data/datasources/group_datasource_interface.dart';
import 'package:uit_buddy_mobile/features/profile/data/models/group_model.dart';

class GroupDatasourceImpl implements GroupDatasourceInterface {
  @override
  Future<ApiResponse<List<GroupModel>>> getGroups() async {
    try {
      await Future.delayed(const Duration(milliseconds: 500));

      final apiResponse = ApiResponse<List<GroupModel>>(
        data: [
          GroupModel(
            id: '1',
            name: 'UIT Gaming Group',
            description: 'A group for UIT students to share study materials and tips.',
            avatarUrl: 'https://storage.googleapis.com/pod_public/1300/138234.jpg',
          ),
          GroupModel(
            id: '2',
            name: 'UIT Sports Club',
            description: 'A group for UIT students interested in sports and fitness activities.',
            avatarUrl: 'https://storage.googleapis.com/pod_public/1300/138234.jpg',
          ),
          GroupModel(
            id: '3',
            name: 'UIT Tech Enthusiasts',
            description: 'A group for UIT students passionate about technology and programming.',
            avatarUrl: 'https://storage.googleapis.com/pod_public/1300/138234.jpg',
          ),
        ],
        message: 'Groups fetched successfully.',
        statusCode: 200,
      );
      return apiResponse;
    } catch (e) {
      return Future.value(ApiResponse<List<GroupModel>>(
        data: null,
        message: 'Failed to fetch groups.',
        statusCode: 500,
      ));
    }
  }
}
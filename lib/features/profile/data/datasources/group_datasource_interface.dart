import 'package:uit_buddy_mobile/core/network/api/api_response.dart';
import 'package:uit_buddy_mobile/features/profile/data/models/group_model.dart';

abstract interface class GroupDatasourceInterface {
  Future<ApiResponse<List<GroupModel>>> getGroups();
}
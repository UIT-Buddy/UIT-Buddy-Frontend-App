import 'package:uit_buddy_mobile/core/network/api/api_response.dart';
import 'package:uit_buddy_mobile/features/profile/data/models/profile_model.dart';

abstract interface class ProfileDatasourceInterface {
  Future<ApiResponse<ProfileModel>> getProfile({required String email});
}

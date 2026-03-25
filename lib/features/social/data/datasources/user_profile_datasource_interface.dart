import 'package:uit_buddy_mobile/core/network/api/api_response.dart';
import 'package:uit_buddy_mobile/features/social/data/models/other_people_model.dart';

abstract interface class UserProfileDatasourceInterface {
  Future<ApiResponse<OtherPeopleModel>> getUserProfile(String mssv);
}

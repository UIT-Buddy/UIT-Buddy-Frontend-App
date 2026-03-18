import 'package:uit_buddy_mobile/core/network/api/api_response.dart';
import 'package:uit_buddy_mobile/features/session/data/models/user_model.dart';

abstract interface class SessionDatasourceInterface {
  Future<ApiResponse<UserModel>> getCurrentUser();
}

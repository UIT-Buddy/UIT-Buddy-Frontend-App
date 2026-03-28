import 'package:uit_buddy_mobile/core/network/api/api_response.dart';
import 'package:uit_buddy_mobile/features/social/data/models/friend_list_item_model.dart';
import 'package:uit_buddy_mobile/features/social/data/models/other_people_model.dart';
import 'package:uit_buddy_mobile/features/social/domain/repositories/user_profile_repository.dart';

abstract interface class UserProfileDatasourceInterface {
  Future<ApiResponse<OtherPeopleModel>> getUserProfile(String mssv);

  Future<ApiResponse<List<FriendListItemModel>>> getFriends({int limit = 100});

  Future<ApiResponse<void>> toggleFriendRequest(String receiverMssv);

  Future<ApiResponse<void>> respondToFriendRequest({
    required String senderMssv,
    required FriendRequestResponseAction action,
  });

  Future<ApiResponse<void>> unfriend(String friendMssv);
}

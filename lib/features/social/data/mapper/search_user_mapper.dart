import 'package:uit_buddy_mobile/features/social/data/models/other_people_model.dart';
import 'package:uit_buddy_mobile/features/social/data/models/search_user_model.dart';
import 'package:uit_buddy_mobile/features/social/domain/entities/other_people_entity.dart';
import 'package:uit_buddy_mobile/features/social/domain/entities/search_user_entity.dart';

extension SearchUserModelMapper on SearchUserModel {
  SearchUserEntity toEntity() => SearchUserEntity(
    mssv: mssv,
    fullName: fullName,
    avatarUrl: avatarUrl,
    friendStatus: _mapFriendStatus(friendStatus),
  );
}

extension OtherPeopleModelMapper on OtherPeopleModel {
  OtherPeopleEntity toEntity() => OtherPeopleEntity(
    mssv: mssv,
    fullName: fullName,
    email: email,
    bio: bio,
    homeClassCode: homeClassCode,
    cometUid: cometUid,
    avatarUrl: avatarUrl,
    friendStatus: _mapFriendStatus(friendStatus),
  );
}

FriendStatus _mapFriendStatus(String? rawValue) {
  final normalized = rawValue?.trim().toUpperCase().replaceAll('-', '_');

  switch (normalized) {
    case 'FRIENDS':
    case 'FRIEND':
    case 'ACCEPTED':
      return FriendStatus.friends;
    case 'PENDING':
    case 'SENT':
      return FriendStatus.pending;
    case 'REQUESTED':
    case 'RECEIVED':
      return FriendStatus.requested;
    case 'NONE':
    case 'NOT_FRIEND':
    case 'NOT_FRIENDS':
    case 'STRANGER':
    case '':
    case null:
      return FriendStatus.none;
    default:
      return FriendStatus.none;
  }
}

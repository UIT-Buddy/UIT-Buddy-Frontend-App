import 'package:uit_buddy_mobile/features/social/domain/entities/search_user_entity.dart';

class OtherPeopleEntity {
  final String mssv;
  final String fullName;
  final String email;
  final String? bio;
  final String? avatarUrl;
  final String? homeClassCode;
  final String? cometUid;
  final FriendStatus friendStatus;

  OtherPeopleEntity({
    required this.mssv,
    required this.fullName,
    required this.email,
    this.bio,
    this.avatarUrl,
    this.homeClassCode,
    this.cometUid,
    this.friendStatus = FriendStatus.none,
  });

  String get userLetterAvatar => fullName.trim().isNotEmpty
      ? fullName.trim().split(' ').last[0].toUpperCase()
      : '?';
}

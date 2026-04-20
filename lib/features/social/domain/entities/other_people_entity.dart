import 'package:uit_buddy_mobile/features/social/domain/entities/search_user_entity.dart';

class OtherPeopleEntity {
  final String mssv;
  final String fullName;
  final String email;
  final String? bio;
  final String? avatarUrl;
  final String? coverUrl;
  final String? homeClassCode;
  final String? cometUid;
  final FriendStatus friendStatus;

  OtherPeopleEntity({
    required this.mssv,
    required this.fullName,
    required this.email,
    this.bio,
    this.avatarUrl,
    this.coverUrl,
    this.homeClassCode,
    this.cometUid,
    this.friendStatus = FriendStatus.none,
  });

  OtherPeopleEntity copyWith({
    String? mssv,
    String? fullName,
    String? email,
    String? bio,
    String? avatarUrl,
    String? coverUrl,
    String? homeClassCode,
    String? cometUid,
    FriendStatus? friendStatus,
  }) {
    return OtherPeopleEntity(
      mssv: mssv ?? this.mssv,
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      bio: bio ?? this.bio,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      coverUrl: coverUrl ?? this.coverUrl,
      homeClassCode: homeClassCode ?? this.homeClassCode,
      cometUid: cometUid ?? this.cometUid,
      friendStatus: friendStatus ?? this.friendStatus,
    );
  }

  String get userLetterAvatar => fullName.trim().isNotEmpty
      ? fullName.trim().split(' ').last[0].toUpperCase()
      : '?';
}

import 'package:uit_buddy_mobile/features/session/data/models/user_model.dart';
import 'package:uit_buddy_mobile/features/session/domain/entities/user_entity.dart';

extension UserModelMapper on UserModel {
  UserEntity toEntity() => UserEntity(
    mssv: mssv,
    fullName: fullName,
    email: email,
    avatarUrl: avatarUrl,
    bio: bio,
    homeClassCode: homeClassCode,
    cometUid: cometUid,
  );
}

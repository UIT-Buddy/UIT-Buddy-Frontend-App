import 'package:uit_buddy_mobile/features/profile/data/models/your_info_model.dart'
    as model;
import 'package:uit_buddy_mobile/features/profile/domain/entities/your_info_entity.dart'
    as entity;

extension YourInfoModelMapper on model.YourInfoModel {
  entity.YourInfoEntity toEntity() => entity.YourInfoEntity(
    mssv: mssv,
    fullName: fullName,
    email: email,
    avatarUrl: avatarUrl,
    coverUrl: coverUrl,
    bio: bio,
    homeClassCode: homeClassCode,
    friendStatus: friendStatus,
    accumulatedGpa: accumulatedGpa,
    accumulatedCredits: accumulatedCredits,
    postCount: postCount,
  );
}

extension YourInfoEntityMapper on entity.YourInfoEntity {
  model.YourInfoModel toModel() => model.YourInfoModel(
    mssv: mssv,
    fullName: fullName,
    email: email,
    avatarUrl: avatarUrl,
    coverUrl: coverUrl,
    bio: bio,
    homeClassCode: homeClassCode,
    friendStatus: friendStatus,
    accumulatedGpa: accumulatedGpa,
    accumulatedCredits: accumulatedCredits,
    postCount: postCount,
  );
}

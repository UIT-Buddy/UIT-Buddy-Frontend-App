import 'package:uit_buddy_mobile/features/profile/data/models/profile_model.dart'
    as model;
import 'package:uit_buddy_mobile/features/profile/domain/entities/profile_entity.dart'
    as entity;

extension ProfileMapper on model.ProfileModel {
  entity.ProfileEntity toEntity() => entity.ProfileEntity(
    mssv: mssv,
    fullName: fullName,
    email: email,
    avatarUrl: avatarUrl,
    bio: bio,
    coverUrl: coverUrl,
    homeClassCode: homeClassCode,
    friendStatus: friendStatus,
    stats: stats.toEntity(),
  );
}

extension ProfileStatsMapper on model.ProfileStatsModel {
  entity.ProfileStatsEntity toEntity() => entity.ProfileStatsEntity(
    accumulatedGpaScale10: accumulatedGpaScale10,
    accumulatedGpaScale4: accumulatedGpaScale4,
    accumulatedCredits: accumulatedCredits,
    totalCredits: totalCredits,
    posts: posts,
    comments: comments,
  );
}

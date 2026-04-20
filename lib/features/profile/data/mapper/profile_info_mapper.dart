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
    currentGpa: currentGpa,
    gpaOn4Scale: gpaOn4Scale,
    accumulatedCredits: accumulatedCredits,
    totalCredits: totalCredits,
    posts: posts,
    comments: comments,
  );
}

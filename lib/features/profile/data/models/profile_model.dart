import 'package:freezed_annotation/freezed_annotation.dart';

part 'profile_model.freezed.dart';
part 'profile_model.g.dart';

@freezed
abstract class ProfileModel with _$ProfileModel {
  const ProfileModel._();

  const factory ProfileModel({
    required String mssv,
    required String fullName,
    required String email,
    required String avatarUrl,
    required String bio,
    required String coverUrl,
    required String homeClassCode,
    required String friendStatus,
    required ProfileStatsModel stats,
  }) = _ProfileModel;

  factory ProfileModel.fromJson(Map<String, dynamic> json) =>
      _$ProfileModelFromJson(json);

  factory ProfileModel.fromMeJson(Map<String, dynamic> json) {
    final data = (json['data'] as Map<String, dynamic>? ?? json);

    final accumulatedGpaScale10 =
        (data['accumulatedGpaScale10'] as num?)?.toDouble() ?? 0;
    final accumulatedGpaScale4 =
        (data['accumulatedGpaScale4'] as num?)?.toDouble() ?? 0;

    return ProfileModel(
      mssv: (data['mssv'] as String?) ?? '',
      fullName: (data['fullName'] as String?) ?? '',
      email: (data['email'] as String?) ?? '',
      avatarUrl:
          (data['avatarUrl'] as String?) ??
          'assets/images/placeholder/user-icon.png',
      bio: (data['bio'] as String?) ?? '-',
      coverUrl:
          (data['coverUrl'] as String?) ??
          'assets/images/placeholder/bg-placeholder-transparent.png',
      homeClassCode: (data['homeClassCode'] as String?) ?? '-',
      friendStatus: (data['friendStatus'] as String?) ?? 'NONE',
      stats: ProfileStatsModel(
        accumulatedGpaScale10: accumulatedGpaScale10,
        accumulatedGpaScale4: accumulatedGpaScale4,
        accumulatedCredits: (data['accumulatedCredits'] as num?)?.toInt() ?? 0,
        totalCredits: (data['totalCredits'] as num?)?.toInt() ?? 0,
        posts:
            (data['postCount'] as num?)?.toInt() ??
            (data['posts'] as num?)?.toInt() ??
            0,
        comments: (data['commentCount'] as num?)?.toInt() ?? 0,
      ),
    );
  }
}

@freezed
abstract class ProfileStatsModel with _$ProfileStatsModel {
  const factory ProfileStatsModel({
    required double accumulatedGpaScale10,
    required double accumulatedGpaScale4,
    required int accumulatedCredits,
    required int totalCredits,
    required int posts,
    required int comments,
  }) = _ProfileStatsModel;

  factory ProfileStatsModel.fromJson(Map<String, dynamic> json) =>
      _$ProfileStatsModelFromJson(json);
}

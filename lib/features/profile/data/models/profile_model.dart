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

    final accumulatedGpa = (data['accumulatedGpa'] as num?)?.toDouble();
    final currentGpa =
        (data['currentGpa'] as num?)?.toDouble() ?? accumulatedGpa ?? 0;
    final gpaOn4Scale =
        (data['gpaOn4Scale'] as num?)?.toDouble() ?? accumulatedGpa ?? 0;

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
        currentGpa: currentGpa,
        gpaOn4Scale: gpaOn4Scale,
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
    required double currentGpa,
    required double gpaOn4Scale,
    required int accumulatedCredits,
    required int totalCredits,
    required int posts,
    required int comments,
  }) = _ProfileStatsModel;

  factory ProfileStatsModel.fromJson(Map<String, dynamic> json) =>
      _$ProfileStatsModelFromJson(json);
}

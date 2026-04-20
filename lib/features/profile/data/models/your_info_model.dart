import 'package:freezed_annotation/freezed_annotation.dart';

part 'your_info_model.freezed.dart';
part 'your_info_model.g.dart';

@freezed
abstract class YourInfoModel with _$YourInfoModel {
  const YourInfoModel._();

  const factory YourInfoModel({
    required String mssv,
    required String fullName,
    required String email,
    required String avatarUrl,
    required String coverUrl,
    required String bio,
    required String homeClassCode,
    required String friendStatus,
    required double accumulatedGpa,
    required int accumulatedCredits,
    required int postCount,
  }) = _YourInfoModel;

  factory YourInfoModel.fromJson(Map<String, dynamic> json) =>
      _$YourInfoModelFromJson(json);

  factory YourInfoModel.fromUserJson(
    Map<String, dynamic> json, {
    YourInfoModel? fallback,
  }) {
    final data = (json['data'] as Map<String, dynamic>? ?? json);

    return YourInfoModel(
      mssv: (data['mssv'] as String?) ?? fallback?.mssv ?? '',
      fullName: (data['fullName'] as String?) ?? fallback?.fullName ?? '',
      email: (data['email'] as String?) ?? fallback?.email ?? '',
      avatarUrl:
          (data['avatarUrl'] as String?) ??
          fallback?.avatarUrl ??
          'assets/images/placeholder/user-icon.png',
      coverUrl:
          (data['coverUrl'] as String?) ??
          fallback?.coverUrl ??
          'assets/images/placeholder/bg-placeholder-transparent.png',
      bio: (data['bio'] as String?) ?? fallback?.bio ?? '-',
      homeClassCode:
          (data['homeClassCode'] as String?) ?? fallback?.homeClassCode ?? '-',
      friendStatus:
          (data['friendStatus'] as String?) ?? fallback?.friendStatus ?? 'NONE',
      accumulatedGpa:
          (data['accumulatedGpa'] as num?)?.toDouble() ??
          fallback?.accumulatedGpa ??
          0,
      accumulatedCredits:
          (data['accumulatedCredits'] as num?)?.toInt() ??
          fallback?.accumulatedCredits ??
          0,
      postCount:
          (data['postCount'] as num?)?.toInt() ?? fallback?.postCount ?? 0,
    );
  }

  Map<String, dynamic> toUpdateRequestJson() {
    return {
      'fullName': fullName,
      'email': email,
      'bio': bio,
      'avatarUrl': avatarUrl,
    };
  }
}

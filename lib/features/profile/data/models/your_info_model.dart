import 'package:equatable/equatable.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

@immutable
class YourInfoModel extends Equatable {
  final String mssv;
  final String fullName;
  final String email;
  final String avatarUrl;
  final String bio;
  final String gender;
  final String homeClass;
  final String faculty;
  final String major;

  const YourInfoModel({
    required this.mssv,
    required this.fullName,
    required this.email,
    required this.avatarUrl,
    required this.bio,
    required this.gender,
    required this.homeClass,
    required this.faculty,
    required this.major,
  });

  factory YourInfoModel.fromUserJson(
    Map<String, dynamic> json, {
    YourInfoModel? fallback,
  }) {
    return YourInfoModel(
      mssv: (json['mssv'] as String?) ?? fallback?.mssv ?? '',
      fullName: (json['fullName'] as String?) ?? fallback?.fullName ?? '',
      email: (json['email'] as String?) ?? fallback?.email ?? '',
      avatarUrl:
          (json['avatarUrl'] as String?) ??
          fallback?.avatarUrl ??
          'assets/images/placeholder/user-icon.png',
      bio: (json['bio'] as String?) ?? fallback?.bio ?? '-',
      // Backend currently omits these fields.
      gender: fallback?.gender ?? '-',
      homeClass: fallback?.homeClass ?? '-',
      faculty: fallback?.faculty ?? '-',
      major: fallback?.major ?? '-',
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

  @override
  List<Object?> get props => [
    mssv,
    fullName,
    email,
    avatarUrl,
    bio,
    gender,
    homeClass,
    faculty,
    major,
  ];
}

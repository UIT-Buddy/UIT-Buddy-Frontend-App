import 'package:equatable/equatable.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

@immutable
class ProfileModel extends Equatable {
  final String mssv;
  final String fullName;
  final String email;
  final String avatarUrl;
  final String bio;
  final String coverUrl;
  final ProfileStatsModel stats;

  const ProfileModel({
    required this.mssv,
    required this.fullName,
    required this.email,
    required this.avatarUrl,
    required this.bio,
    required this.coverUrl,
    required this.stats,
  });

  factory ProfileModel.fromMeJson(Map<String, dynamic> json) {
    final data = (json['data'] as Map<String, dynamic>? ?? json);

    return ProfileModel(
      mssv: (data['mssv'] as String?) ?? '',
      fullName: (data['fullName'] as String?) ?? '',
      email: (data['email'] as String?) ?? '',
      avatarUrl: (data['avatarUrl'] as String?) ??
          'assets/images/placeholder/user-icon.png',
      bio: (data['bio'] as String?) ?? '-',
      // Backend /me currently does not return cover and stats.
      coverUrl:
          'assets/images/placeholder/bg-placeholder-transparent.png',
      stats: const ProfileStatsModel(
        currentGpa: 0,
        gpaOn4Scale: 0,
        accumulatedCredits: 0,
        totalCredits: 0,
        posts: 0,
        comments: 0,
      ),
    );
  }

  @override
  List<Object?> get props => [
    mssv,
    fullName,
    email,
    avatarUrl,
    bio,
    coverUrl,
    stats,
  ];
}

@immutable
class ProfileStatsModel extends Equatable {
  final double currentGpa;
  final double gpaOn4Scale;
  final int accumulatedCredits;
  final int totalCredits;
  final int posts;
  final int comments;

  const ProfileStatsModel({
    required this.currentGpa,
    required this.gpaOn4Scale,
    required this.accumulatedCredits,
    required this.totalCredits,
    required this.posts,
    required this.comments,
  });

  @override
  List<Object?> get props => [
    currentGpa,
    gpaOn4Scale,
    accumulatedCredits,
    totalCredits,
    posts,
    comments,
  ];
}

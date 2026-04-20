import 'package:equatable/equatable.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

@immutable
class ProfileEntity extends Equatable {
  final String mssv;
  final String fullName;
  final String email;
  final String avatarUrl;
  final String bio;
  final String coverUrl;
  final String homeClassCode;
  final String friendStatus;
  final ProfileStatsEntity stats;

  const ProfileEntity({
    required this.mssv,
    required this.fullName,
    required this.email,
    required this.avatarUrl,
    required this.bio,
    required this.coverUrl,
    required this.homeClassCode,
    required this.friendStatus,
    required this.stats,
  });

  @override
  List<Object?> get props => [
    mssv,
    fullName,
    email,
    avatarUrl,
    bio,
    coverUrl,
    homeClassCode,
    friendStatus,
    stats,
  ];
}

@immutable
class ProfileStatsEntity extends Equatable {
  final double currentGpa;
  final double gpaOn4Scale;
  final int accumulatedCredits;
  final int totalCredits;
  final int posts;
  final int comments;

  const ProfileStatsEntity({
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

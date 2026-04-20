import 'package:equatable/equatable.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

@immutable
class YourInfoEntity extends Equatable {
  final String mssv;
  final String fullName;
  final String email;
  final String avatarUrl;
  final String coverUrl;
  final String bio;
  final String homeClassCode;
  final String friendStatus;
  final double accumulatedGpa;
  final int accumulatedCredits;
  final int postCount;

  const YourInfoEntity({
    required this.mssv,
    required this.fullName,
    required this.email,
    required this.avatarUrl,
    required this.coverUrl,
    required this.bio,
    required this.homeClassCode,
    required this.friendStatus,
    required this.accumulatedGpa,
    required this.accumulatedCredits,
    required this.postCount,
  });

  @override
  List<Object?> get props => [
    mssv,
    fullName,
    email,
    avatarUrl,
    coverUrl,
    bio,
    homeClassCode,
    friendStatus,
    accumulatedGpa,
    accumulatedCredits,
    postCount,
  ];
}

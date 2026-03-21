import 'package:equatable/equatable.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

@immutable
class YourInfoEntity extends Equatable {
  final String mssv;
  final String fullName;
  final String email;
  final String avatarUrl;
  final String bio;
  final String gender;
  final String homeClass;
  final String faculty;
  final String major;

  const YourInfoEntity({
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

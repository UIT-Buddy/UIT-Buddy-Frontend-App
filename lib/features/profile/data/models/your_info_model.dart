import 'package:equatable/equatable.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

@immutable
class YourInfoModel extends Equatable {
  final String mssv;
  final String fullName;
  final String email;
  final String gender;
  final String homeClass;
  final String faculty;
  final String major;

  const YourInfoModel({
    required this.mssv,
    required this.fullName,
    required this.email,
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
    gender,
    homeClass,
    faculty,
    major,
  ];
}
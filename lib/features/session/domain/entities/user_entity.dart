import 'package:equatable/equatable.dart';

class UserEntity extends Equatable {
  const UserEntity({
    required this.mssv,
    required this.fullName,
    required this.email,
    this.avatarUrl,
    this.bio,
    this.homeClassCode,
    this.cometUid,
  });

  final String mssv;
  final String fullName;
  final String email;
  final String? avatarUrl;
  final String? bio;
  final String? homeClassCode;
  final String? cometUid;

  @override
  List<Object?> get props => [
    mssv,
    fullName,
    email,
    avatarUrl,
    bio,
    homeClassCode,
    cometUid,
  ];

  String get userLetterAvatar => fullName.split(' ').last[0].toUpperCase();
  
}

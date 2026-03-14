import 'package:equatable/equatable.dart';
import 'package:uit_buddy_mobile/features/profile/domain/entities/profile_entity.dart';

enum ProfileStatus { initial, loading, loaded, error, signingOut, signedOut }

class ProfileState extends Equatable {
  const ProfileState({
    this.status = ProfileStatus.initial,
    this.profileInfo,
    this.errorMessage,
  });

  final ProfileStatus status;
  final ProfileEntity? profileInfo;
  final String? errorMessage;

  ProfileState copyWith({
    ProfileStatus? status,
    ProfileEntity? profileInfo,
    String? errorMessage,
  }) {
    return ProfileState(
      status: status ?? this.status,
      profileInfo: profileInfo ?? this.profileInfo,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, profileInfo, errorMessage];
}

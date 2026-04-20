import 'package:equatable/equatable.dart';
import 'package:uit_buddy_mobile/features/profile/domain/entities/profile_entity.dart';

enum ProfileStatus { initial, loading, loaded, error, signingOut, signedOut }

class ProfileState extends Equatable {
  const ProfileState({
    this.status = ProfileStatus.initial,
    this.profileInfo,
    this.errorMessage,
    this.isUploadingCover = false,
    this.actionErrorMessage,
    this.actionSuccessMessage,
  });

  final ProfileStatus status;
  final ProfileEntity? profileInfo;
  final String? errorMessage;
  final bool isUploadingCover;
  final String? actionErrorMessage;
  final String? actionSuccessMessage;

  ProfileState copyWith({
    ProfileStatus? status,
    ProfileEntity? profileInfo,
    String? Function()? errorMessage,
    bool? isUploadingCover,
    String? Function()? actionErrorMessage,
    String? Function()? actionSuccessMessage,
  }) {
    return ProfileState(
      status: status ?? this.status,
      profileInfo: profileInfo ?? this.profileInfo,
      errorMessage: errorMessage != null ? errorMessage() : this.errorMessage,
      isUploadingCover: isUploadingCover ?? this.isUploadingCover,
      actionErrorMessage: actionErrorMessage != null
          ? actionErrorMessage()
          : this.actionErrorMessage,
      actionSuccessMessage: actionSuccessMessage != null
          ? actionSuccessMessage()
          : this.actionSuccessMessage,
    );
  }

  @override
  List<Object?> get props => [
    status,
    profileInfo,
    errorMessage,
    isUploadingCover,
    actionErrorMessage,
    actionSuccessMessage,
  ];
}

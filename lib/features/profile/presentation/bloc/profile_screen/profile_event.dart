import 'package:equatable/equatable.dart';

abstract class ProfileEvent extends Equatable {
  const ProfileEvent();

  @override
  List<Object?> get props => [];
}

class ProfileStarted extends ProfileEvent {
  const ProfileStarted();
}

class ProfileCoverUploadRequested extends ProfileEvent {
  const ProfileCoverUploadRequested({
    required this.fileBytes,
    required this.fileName,
  });

  final List<int> fileBytes;
  final String fileName;

  @override
  List<Object?> get props => [fileBytes, fileName];
}

class ProfileFeedbackCleared extends ProfileEvent {
  const ProfileFeedbackCleared();
}

class SignOutRequested extends ProfileEvent {
  const SignOutRequested();
}

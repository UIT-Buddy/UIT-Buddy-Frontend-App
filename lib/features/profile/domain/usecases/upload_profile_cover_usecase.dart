import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';
import 'package:uit_buddy_mobile/core/error/failures.dart';
import 'package:uit_buddy_mobile/core/usecase/usecase_interface.dart';
import 'package:uit_buddy_mobile/features/profile/domain/repositories/profile_repository.dart';

class UploadProfileCoverUsecase
    implements UseCase<String, UploadProfileCoverParams> {
  UploadProfileCoverUsecase({required ProfileRepository profileRepository})
    : _profileRepository = profileRepository;

  final ProfileRepository _profileRepository;

  @override
  Future<Either<Failure, String>> call(UploadProfileCoverParams params) async =>
      _profileRepository.uploadUserCoverPicture(
        fileBytes: params.fileBytes,
        fileName: params.fileName,
      );
}

class UploadProfileCoverParams extends Equatable {
  const UploadProfileCoverParams({
    required this.fileBytes,
    required this.fileName,
  });

  final List<int> fileBytes;
  final String fileName;

  @override
  List<Object?> get props => [fileBytes, fileName];
}

import 'package:fpdart/fpdart.dart';
import 'package:uit_buddy_mobile/core/error/failures.dart';
import 'package:uit_buddy_mobile/core/usecase/usecase_interface.dart';
import 'package:uit_buddy_mobile/features/profile/domain/entities/profile_entity.dart';
import 'package:uit_buddy_mobile/features/profile/domain/repositories/profile_repository.dart';

class GetProfileUsecase implements UseCase<ProfileEntity, NoParams> {
  GetProfileUsecase({required ProfileRepository profileRepository})
    : _profileRepository = profileRepository;
  final ProfileRepository _profileRepository;
  @override
  Future<Either<Failure, ProfileEntity>> call(NoParams params) async =>
      _profileRepository.getProfile();
}

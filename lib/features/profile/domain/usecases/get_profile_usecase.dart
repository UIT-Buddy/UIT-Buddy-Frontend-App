import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:uit_buddy_mobile/core/error/failures.dart';
import 'package:uit_buddy_mobile/core/usecase/usecase_interface.dart';
import 'package:uit_buddy_mobile/features/profile/domain/entities/profile_entity.dart';
import 'package:uit_buddy_mobile/features/profile/domain/repositories/profile_repository.dart';

class GetProfileUsecase implements UseCase<ProfileEntity, GetProfileParams> {
  GetProfileUsecase({required ProfileRepository profileRepository})
    : _profileRepository = profileRepository;
  final ProfileRepository _profileRepository;
  @override
  Future<Either<Failure, ProfileEntity>> call(GetProfileParams params) async =>
      _profileRepository.getProfile(email: params.email);
}

@immutable
class GetProfileParams extends Equatable {
  const GetProfileParams({required this.email});
  final String email;
  @override
  List<Object?> get props => [email];
}

import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';
import 'package:uit_buddy_mobile/core/error/failures.dart';
import 'package:uit_buddy_mobile/core/usecase/usecase_interface.dart';
import 'package:uit_buddy_mobile/features/social/domain/entities/other_people_entity.dart';
import 'package:uit_buddy_mobile/features/social/domain/repositories/user_profile_repository.dart';

class GetUserProfileUsecase
    implements UseCase<OtherPeopleEntity, GetUserProfileParams> {
  GetUserProfileUsecase({required UserProfileRepository repository})
    : _repository = repository;

  final UserProfileRepository _repository;

  @override
  Future<Either<Failure, OtherPeopleEntity>> call(
    GetUserProfileParams params,
  ) => _repository.getUserProfile(params.mssv);
}

class GetUserProfileParams extends Equatable {
  const GetUserProfileParams({required this.mssv});

  final String mssv;

  @override
  List<Object?> get props => [mssv];
}

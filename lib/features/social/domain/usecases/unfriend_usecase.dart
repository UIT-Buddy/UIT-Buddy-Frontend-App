import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';
import 'package:uit_buddy_mobile/core/error/failures.dart';
import 'package:uit_buddy_mobile/core/usecase/usecase_interface.dart';
import 'package:uit_buddy_mobile/features/social/domain/repositories/user_profile_repository.dart';

class UnfriendUsecase implements UseCase<Unit, UnfriendParams> {
  UnfriendUsecase({required UserProfileRepository repository})
    : _repository = repository;

  final UserProfileRepository _repository;

  @override
  Future<Either<Failure, Unit>> call(UnfriendParams params) =>
      _repository.unfriend(params.friendMssv);
}

class UnfriendParams extends Equatable {
  const UnfriendParams({required this.friendMssv});

  final String friendMssv;

  @override
  List<Object?> get props => [friendMssv];
}

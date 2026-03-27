import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';
import 'package:uit_buddy_mobile/core/error/failures.dart';
import 'package:uit_buddy_mobile/core/usecase/usecase_interface.dart';
import 'package:uit_buddy_mobile/features/social/domain/repositories/user_profile_repository.dart';

class ToggleFriendRequestUsecase
    implements UseCase<Unit, ToggleFriendRequestParams> {
  ToggleFriendRequestUsecase({required UserProfileRepository repository})
    : _repository = repository;

  final UserProfileRepository _repository;

  @override
  Future<Either<Failure, Unit>> call(ToggleFriendRequestParams params) =>
      _repository.toggleFriendRequest(params.receiverMssv);
}

class ToggleFriendRequestParams extends Equatable {
  const ToggleFriendRequestParams({required this.receiverMssv});

  final String receiverMssv;

  @override
  List<Object?> get props => [receiverMssv];
}

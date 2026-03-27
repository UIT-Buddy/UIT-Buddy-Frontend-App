import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';
import 'package:uit_buddy_mobile/core/error/failures.dart';
import 'package:uit_buddy_mobile/core/usecase/usecase_interface.dart';
import 'package:uit_buddy_mobile/features/social/domain/repositories/user_profile_repository.dart';

class RespondFriendRequestUsecase
    implements UseCase<Unit, RespondFriendRequestParams> {
  RespondFriendRequestUsecase({required UserProfileRepository repository})
    : _repository = repository;

  final UserProfileRepository _repository;

  @override
  Future<Either<Failure, Unit>> call(RespondFriendRequestParams params) =>
      _repository.respondToFriendRequest(
        senderMssv: params.senderMssv,
        action: params.action,
      );
}

class RespondFriendRequestParams extends Equatable {
  const RespondFriendRequestParams({
    required this.senderMssv,
    required this.action,
  });

  final String senderMssv;
  final FriendRequestResponseAction action;

  @override
  List<Object?> get props => [senderMssv, action];
}

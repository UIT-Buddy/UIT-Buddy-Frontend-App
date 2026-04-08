import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';
import 'package:uit_buddy_mobile/core/error/failures.dart';
import 'package:uit_buddy_mobile/core/usecase/usecase_interface.dart';
import 'package:uit_buddy_mobile/features/profile/domain/repositories/friend_repository.dart';

class RespondFriendRequestUsecase
    implements UseCase<Unit, RespondFriendParams> {
  RespondFriendRequestUsecase({required FriendRepository friendRepository})
    : _friendRepository = friendRepository;

  final FriendRepository _friendRepository;

  @override
  Future<Either<Failure, Unit>> call(RespondFriendParams params) async =>
      _friendRepository.respondToFriendRequest(
        action: params.action,
        senderMssv: params.senderMssv,
      );
}

class RespondFriendParams extends Equatable {
  final String action;
  final String senderMssv;

  const RespondFriendParams({required this.action, required this.senderMssv});

  @override
  List<Object?> get props => [action, senderMssv];
}

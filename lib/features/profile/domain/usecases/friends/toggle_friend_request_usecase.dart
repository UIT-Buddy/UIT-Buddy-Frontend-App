import 'package:fpdart/fpdart.dart';
import 'package:uit_buddy_mobile/core/error/failures.dart';
import 'package:uit_buddy_mobile/core/usecase/usecase_interface.dart';
import 'package:uit_buddy_mobile/features/profile/domain/repositories/friend_repository.dart';

class ToggleFriendRequestUsecase implements UseCase<Unit, String> {
  ToggleFriendRequestUsecase({required FriendRepository friendRepository})
    : _friendRepository = friendRepository;

  final FriendRepository _friendRepository;

  @override
  Future<Either<Failure, Unit>> call(String receiverMssv) async =>
      _friendRepository.toggleFriendRequest(receiverMssv: receiverMssv);
}

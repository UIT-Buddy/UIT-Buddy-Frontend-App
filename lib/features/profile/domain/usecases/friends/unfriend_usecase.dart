import 'package:fpdart/fpdart.dart';
import 'package:uit_buddy_mobile/core/error/failures.dart';
import 'package:uit_buddy_mobile/core/usecase/usecase_interface.dart';
import 'package:uit_buddy_mobile/features/profile/domain/repositories/friend_repository.dart';

class UnfriendUsecase implements UseCase<Unit, String> {
  UnfriendUsecase({required FriendRepository friendRepository})
    : _friendRepository = friendRepository;

  final FriendRepository _friendRepository;

  @override
  Future<Either<Failure, Unit>> call(String friendMssv) async =>
      _friendRepository.unFriend(friendMssv: friendMssv);
}

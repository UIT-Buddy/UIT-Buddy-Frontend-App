import 'package:fpdart/fpdart.dart';
import 'package:uit_buddy_mobile/core/error/failures.dart';
import 'package:uit_buddy_mobile/features/social/domain/entities/other_people_entity.dart';

enum FriendRequestResponseAction { accept, reject }

extension FriendRequestResponseActionX on FriendRequestResponseAction {
  String get apiValue => switch (this) {
    FriendRequestResponseAction.accept => 'ACCEPT',
    FriendRequestResponseAction.reject => 'REJECT',
  };
}

abstract interface class UserProfileRepository {
  Future<Either<Failure, OtherPeopleEntity>> getUserProfile(String mssv);

  Future<Either<Failure, Unit>> toggleFriendRequest(String receiverMssv);

  Future<Either<Failure, Unit>> respondToFriendRequest({
    required String senderMssv,
    required FriendRequestResponseAction action,
  });

  Future<Either<Failure, Unit>> unfriend(String friendMssv);
}

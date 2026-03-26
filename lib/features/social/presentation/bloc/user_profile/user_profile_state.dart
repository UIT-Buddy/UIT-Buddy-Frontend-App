import 'package:equatable/equatable.dart';
import 'package:uit_buddy_mobile/features/social/domain/entities/other_people_entity.dart';

enum UserProfileStatus { initial, loading, loaded, error }

class UserProfileState extends Equatable {
  const UserProfileState({
    this.status = UserProfileStatus.initial,
    this.user,
    this.errorMessage,
  });

  final UserProfileStatus status;
  final OtherPeopleEntity? user;
  final String? errorMessage;

  UserProfileState copyWith({
    UserProfileStatus? status,
    OtherPeopleEntity? user,
    Object? errorMessage = _sentinel,
  }) {
    return UserProfileState(
      status: status ?? this.status,
      user: user ?? this.user,
      errorMessage: identical(errorMessage, _sentinel)
          ? this.errorMessage
          : errorMessage as String?,
    );
  }

  @override
  List<Object?> get props => [status, user, errorMessage];
}

const Object _sentinel = Object();

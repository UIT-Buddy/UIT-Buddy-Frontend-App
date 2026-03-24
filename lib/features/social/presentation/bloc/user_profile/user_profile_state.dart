import 'package:equatable/equatable.dart';
import 'package:uit_buddy_mobile/features/session/domain/entities/user_entity.dart';

enum UserProfileStatus { initial, loading, loaded, error }

class UserProfileState extends Equatable {
  const UserProfileState({
    this.status = UserProfileStatus.initial,
    this.user,
    this.errorMessage,
  });

  final UserProfileStatus status;
  final UserEntity? user;
  final String? errorMessage;

  UserProfileState copyWith({
    UserProfileStatus? status,
    UserEntity? user,
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

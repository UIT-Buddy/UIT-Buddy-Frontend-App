import 'package:fpdart/fpdart.dart';
import 'package:uit_buddy_mobile/core/error/failures.dart';
import 'package:uit_buddy_mobile/features/session/domain/entities/user_entity.dart';

abstract interface class UserProfileRepository {
  Future<Either<Failure, UserEntity>> getUserProfile(String mssv);
}

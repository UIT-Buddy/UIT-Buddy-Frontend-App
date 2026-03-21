import 'package:fpdart/fpdart.dart';
import 'package:uit_buddy_mobile/core/error/failures.dart';
import 'package:uit_buddy_mobile/features/session/domain/entities/user_entity.dart';

abstract interface class SessionRepository {
  Future<Either<Failure, UserEntity>> getCurrentUser();
}

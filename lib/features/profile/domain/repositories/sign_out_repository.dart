import 'package:fpdart/fpdart.dart';
import 'package:uit_buddy_mobile/core/error/failures.dart';

abstract interface class SignOutRepository {
  Future<Either<Failure, void>> signOut();
}

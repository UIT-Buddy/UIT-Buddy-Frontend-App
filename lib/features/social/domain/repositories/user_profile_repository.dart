import 'package:fpdart/fpdart.dart';
import 'package:uit_buddy_mobile/core/error/failures.dart';
import 'package:uit_buddy_mobile/features/social/domain/entities/other_people_entity.dart';

abstract interface class UserProfileRepository {
  Future<Either<Failure, OtherPeopleEntity>> getUserProfile(String mssv);
}

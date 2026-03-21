import 'package:fpdart/fpdart.dart';
import 'package:uit_buddy_mobile/core/error/failures.dart';
import 'package:uit_buddy_mobile/features/profile/domain/entities/group_entity.dart';

abstract interface class GroupRepository {
  Future<Either<Failure, List<GroupEntity>>> getGroups();
}

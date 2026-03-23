import 'package:fpdart/fpdart.dart';
import 'package:uit_buddy_mobile/core/error/failures.dart';
import 'package:uit_buddy_mobile/core/usecase/usecase_interface.dart';
import 'package:uit_buddy_mobile/features/profile/domain/entities/group_entity.dart';
import 'package:uit_buddy_mobile/features/profile/domain/repositories/group_repository.dart';

class GetGroupsUsecase implements UseCase<List<GroupEntity>, NoParams> {
  GetGroupsUsecase({required GroupRepository groupRepository})
    : _repository = groupRepository;

  final GroupRepository _repository;
  @override
  Future<Either<Failure, List<GroupEntity>>> call(NoParams params) async =>
      _repository.getGroups();
}

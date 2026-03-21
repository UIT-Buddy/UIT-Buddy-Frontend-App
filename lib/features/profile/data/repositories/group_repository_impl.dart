import 'package:fpdart/fpdart.dart';
import 'package:uit_buddy_mobile/core/error/failures.dart';
import 'package:uit_buddy_mobile/features/profile/data/datasources/group_datasource_interface.dart';
import 'package:uit_buddy_mobile/features/profile/data/mapper/group_mapper.dart';
import 'package:uit_buddy_mobile/features/profile/domain/entities/group_entity.dart';
import 'package:uit_buddy_mobile/features/profile/domain/repositories/group_repository.dart';

class GroupRepositoryImpl implements GroupRepository {
  GroupRepositoryImpl({
    required GroupDatasourceInterface groupDatasourceInterface,
  }) : _groupDatasourceInterface = groupDatasourceInterface;

  final GroupDatasourceInterface _groupDatasourceInterface;

  @override
  Future<Either<Failure, List<GroupEntity>>> getGroups() async {
    try {
      final apiResponse = await _groupDatasourceInterface.getGroups();

      if (apiResponse.data == null) {
        return Left(Failure(apiResponse.message));
      }

      return Right(apiResponse.data!.map((m) => m.toEntity()).toList());
    } on Exception catch (e) {
      return Left(Failure.fromException(e));
    }
  }
}

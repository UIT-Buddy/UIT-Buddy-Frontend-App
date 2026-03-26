import 'package:fpdart/fpdart.dart';
import 'package:uit_buddy_mobile/core/error/failures.dart';
import 'package:uit_buddy_mobile/features/social/data/datasources/user_profile_datasource_interface.dart';
import 'package:uit_buddy_mobile/features/social/data/mapper/search_user_mapper.dart';
import 'package:uit_buddy_mobile/features/social/domain/entities/other_people_entity.dart';
import 'package:uit_buddy_mobile/features/social/domain/repositories/user_profile_repository.dart';

class UserProfileRepositoryImpl implements UserProfileRepository {
  UserProfileRepositoryImpl({
    required UserProfileDatasourceInterface datasource,
  }) : _datasource = datasource;

  final UserProfileDatasourceInterface _datasource;

  @override
  Future<Either<Failure, OtherPeopleEntity>> getUserProfile(String mssv) async {
    try {
      final response = await _datasource.getUserProfile(mssv);
      return Right(response.data!.toEntity());
    } on Exception catch (e) {
      return Left(Failure.fromException(e));
    }
  }
}

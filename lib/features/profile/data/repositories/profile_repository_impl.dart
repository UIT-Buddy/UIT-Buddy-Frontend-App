import 'package:fpdart/fpdart.dart';
import 'package:uit_buddy_mobile/core/error/failures.dart';
import 'package:uit_buddy_mobile/features/profile/data/datasources/profile_datasource_interface.dart';
import 'package:uit_buddy_mobile/features/profile/data/mapper/profile_info_mapper.dart';
import 'package:uit_buddy_mobile/features/profile/domain/entities/profile_entity.dart';
import 'package:uit_buddy_mobile/features/profile/domain/repositories/profile_repository.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  ProfileRepositoryImpl({
    required ProfileDatasourceInterface profileDatasourceInterface,
  }) : _profileDatasourceInterface = profileDatasourceInterface;

  final ProfileDatasourceInterface _profileDatasourceInterface;

  @override
  Future<Either<Failure, ProfileEntity>> getProfile() async {
    try {
      final apiResponse = await _profileDatasourceInterface.getProfile();

      if (apiResponse.data == null) {
        return Left(Failure(apiResponse.message));
      }

      return Right(apiResponse.data!.toEntity());
    } on Exception catch (e) {
      return Left(Failure.fromException(e));
    }
  }

  @override
  Future<Either<Failure, String>> uploadUserCoverPicture({
    required List<int> fileBytes,
    required String fileName,
  }) async {
    try {
      final apiResponse = await _profileDatasourceInterface
          .uploadUserCoverPicture(fileBytes: fileBytes, fileName: fileName);

      return Right(apiResponse.data ?? '');
    } on Exception catch (e) {
      return Left(Failure.fromException(e));
    }
  }
}

import 'package:fpdart/fpdart.dart';
import 'package:uit_buddy_mobile/core/error/failures.dart';
import 'package:uit_buddy_mobile/features/profile/data/datasources/your_info_datasource_interface.dart';
import 'package:uit_buddy_mobile/features/profile/data/mapper/your_info_mapper.dart';
import 'package:uit_buddy_mobile/features/profile/domain/entities/your_info_entity.dart';
import 'package:uit_buddy_mobile/features/profile/domain/repositories/your_info_repository.dart';

class YourInfoRepositoryImpl implements YourInfoRepository {
  YourInfoRepositoryImpl(
      {required YourInfoDatasourceInterface yourInfoDatasourceInterface})
      : _yourInfoDatasourceInterface = yourInfoDatasourceInterface;
  final YourInfoDatasourceInterface _yourInfoDatasourceInterface;

  @override
  Future<Either<Failure, YourInfoEntity>> getYourInfo() async {
    try {
      final apiResponse = await _yourInfoDatasourceInterface.getYourInfo();
      if (apiResponse.data == null) {
        return Left(Failure(apiResponse.message));
      }
      return Right(apiResponse.data!.toEntity());
    } on Exception catch (e) {
      return Left(Failure.fromException(e));
    }
  }

  @override
  Future<Either<Failure, YourInfoEntity>> updateYourInfo(
      YourInfoEntity yourInfo) async {
    try {
      final apiResponse = await _yourInfoDatasourceInterface.updateYourInfo(
        info: yourInfo.toModel(),
      );
      if (apiResponse.data == null) {
        return Left(Failure(apiResponse.message));
      }
      return Right(apiResponse.data!.toEntity());
    } on Exception catch (e) {
      return Left(Failure.fromException(e));
    }
  }
}
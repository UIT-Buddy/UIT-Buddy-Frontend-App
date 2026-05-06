import 'package:fpdart/fpdart.dart';
import 'package:uit_buddy_mobile/core/error/failures.dart';
import 'package:uit_buddy_mobile/features/home/data/datasources/homepage_datasource.dart';
import 'package:uit_buddy_mobile/features/home/data/mapper/homepage_mapper.dart';
import 'package:uit_buddy_mobile/features/home/domain/entities/homepage_entity.dart';
import 'package:uit_buddy_mobile/features/home/domain/repositories/homepage_repository.dart';

class HomepageRepositoryImpl implements HomepageRepository {
  HomepageRepositoryImpl({required HomepageDatasource homepageDatasource})
    : _homepageDatasource = homepageDatasource;

  final HomepageDatasource _homepageDatasource;

  @override
  Future<Either<Failure, HomePageEntity>> getHomepageData({
    int page = 1,
    int limit = 10,
    String sortType = 'desc',
    String sortBy = 'createdAt',
  }) async {
    try {
      final model = await _homepageDatasource.getHomePageData(
        page: page,
        limit: limit,
        sortType: sortType,
        sortBy: sortBy,
      );
      return Right(model.toEntity());
    } on Exception catch (e) {
      return Left(Failure.fromException(e));
    }
  }
}

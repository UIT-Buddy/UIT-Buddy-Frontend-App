import 'package:fpdart/fpdart.dart';
import 'package:uit_buddy_mobile/core/error/failures.dart';
import 'package:uit_buddy_mobile/features/home/domain/entities/homepage_entity.dart';

abstract interface class HomepageRepository {
  Future<Either<Failure, HomePageEntity>> getHomepageData({
    int page,
    int limit = 10,
    String sortType,
    String sortBy,
  });
}

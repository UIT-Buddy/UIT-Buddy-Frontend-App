import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';
import 'package:uit_buddy_mobile/core/error/failures.dart';
import 'package:uit_buddy_mobile/core/usecase/usecase_interface.dart';
import 'package:uit_buddy_mobile/features/home/domain/entities/homepage_entity.dart';
import 'package:uit_buddy_mobile/features/home/domain/repositories/homepage_repository.dart';

class GetHomepageDataUsecase
    implements UseCase<HomePageEntity, HomepageParams> {
  final HomepageRepository repository;

  GetHomepageDataUsecase(this.repository);

  @override
  Future<Either<Failure, HomePageEntity>> call(HomepageParams params) async {
    return await repository.getHomepageData(
      page: params.page,
      limit: params.limit,
      sortType: params.sortType,
      sortBy: params.sortBy,
    );
  }
}

class HomepageParams extends Equatable {
  final int page;
  final int limit;
  final String sortType;
  final String sortBy;

  const HomepageParams({
    this.page = 1,
    this.limit = 10,
    this.sortType = 'desc',
    this.sortBy = 'createdAt',
  });

  @override
  List<Object?> get props => [page, limit, sortType, sortBy];
}

import 'package:fpdart/fpdart.dart';
import 'package:uit_buddy_mobile/core/common/paged_result.dart';
import 'package:uit_buddy_mobile/core/error/failures.dart';
import 'package:uit_buddy_mobile/features/social/data/datasources/user_search_datasource_interface.dart';
import 'package:uit_buddy_mobile/features/social/data/datasources/user_profile_datasource_interface.dart';
import 'package:uit_buddy_mobile/features/social/data/mapper/search_user_mapper.dart';
import 'package:uit_buddy_mobile/features/social/domain/entities/search_user_entity.dart';
import 'package:uit_buddy_mobile/features/social/domain/repositories/user_search_repository.dart';

class UserSearchRepositoryImpl implements UserSearchRepository {
  UserSearchRepositoryImpl({
    required UserSearchDatasourceInterface datasource,
    required UserProfileDatasourceInterface userProfileDatasource,
  }) : _datasource = datasource,
       _userProfileDatasource = userProfileDatasource;

  final UserSearchDatasourceInterface _datasource;
  final UserProfileDatasourceInterface _userProfileDatasource;

  @override
  Future<Either<Failure, PagedResult<SearchUserEntity>>> searchUsers({
    required String keyword,
    int page = 1,
    int limit = 10,
    String? sortBy,
    String? sortType,
  }) async {
    try {
      final result = await _datasource.searchUsers(
        keyword: keyword,
        page: page,
        limit: limit,
        sortBy: sortBy,
        sortType: sortType,
      );

      return Right(
        PagedResult<SearchUserEntity>(
          items: result.items.map((item) => item.toEntity()).toList(),
          nextCursor: result.nextCursor,
          hasMore: result.hasMore,
        ),
      );
    } on Exception catch (e) {
      return Left(Failure.fromException(e));
    }
  }


  
}

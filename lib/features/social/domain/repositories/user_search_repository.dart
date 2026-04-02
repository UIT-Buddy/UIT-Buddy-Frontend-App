import 'package:fpdart/fpdart.dart';
import 'package:uit_buddy_mobile/core/common/paged_result.dart';
import 'package:uit_buddy_mobile/core/error/failures.dart';
import 'package:uit_buddy_mobile/features/social/domain/entities/search_user_entity.dart';

abstract interface class UserSearchRepository {
  Future<Either<Failure, PagedResult<SearchUserEntity>>> searchUsers({
    required String keyword,
    int page = 1,
    int limit = 10,
    String? sortBy,
    String? sortType,
  });

 
 
}

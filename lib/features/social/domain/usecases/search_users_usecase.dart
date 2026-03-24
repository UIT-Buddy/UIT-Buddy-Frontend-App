import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';
import 'package:uit_buddy_mobile/core/common/paged_result.dart';
import 'package:uit_buddy_mobile/core/error/failures.dart';
import 'package:uit_buddy_mobile/core/usecase/usecase_interface.dart';
import 'package:uit_buddy_mobile/features/social/domain/entities/search_user_entity.dart';
import 'package:uit_buddy_mobile/features/social/domain/repositories/user_search_repository.dart';

class SearchUsersUsecase
    implements UseCase<PagedResult<SearchUserEntity>, SearchUsersParams> {
  SearchUsersUsecase({required UserSearchRepository repository})
    : _repository = repository;

  final UserSearchRepository _repository;

  @override
  Future<Either<Failure, PagedResult<SearchUserEntity>>> call(
    SearchUsersParams params,
  ) => _repository.searchUsers(
    keyword: params.keyword,
    page: params.page,
    limit: params.limit,
    sortBy: params.sortBy,
    sortType: params.sortType,
  );
}

class SearchUsersParams extends Equatable {
  const SearchUsersParams({
    required this.keyword,
    this.page = 1,
    this.limit = 10,
    this.sortBy,
    this.sortType,
  });

  final String keyword;
  final int page;
  final int limit;
  final String? sortBy;
  final String? sortType;

  @override
  List<Object?> get props => [keyword, page, limit, sortBy, sortType];
}

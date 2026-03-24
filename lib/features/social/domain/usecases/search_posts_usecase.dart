import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';
import 'package:uit_buddy_mobile/core/common/paged_result.dart';
import 'package:uit_buddy_mobile/core/error/failures.dart';
import 'package:uit_buddy_mobile/core/usecase/usecase_interface.dart';
import 'package:uit_buddy_mobile/features/social/domain/entities/post_entity.dart';
import 'package:uit_buddy_mobile/features/social/domain/repositories/post_repository.dart';

class SearchPostsUsecase
    implements UseCase<PagedResult<PostEntity>, SearchPostsParams> {
  SearchPostsUsecase({required PostRepository repository})
    : _repository = repository;

  final PostRepository _repository;

  @override
  Future<Either<Failure, PagedResult<PostEntity>>> call(
    SearchPostsParams params,
  ) => _repository.searchPosts(
    keyword: params.keyword,
    page: params.page,
    limit: params.limit,
    sortBy: params.sortBy,
    sortType: params.sortType,
  );
}

class SearchPostsParams extends Equatable {
  const SearchPostsParams({
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

import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';
import 'package:uit_buddy_mobile/core/common/paged_result.dart';
import 'package:uit_buddy_mobile/core/error/failures.dart';
import 'package:uit_buddy_mobile/core/usecase/usecase_interface.dart';
import 'package:uit_buddy_mobile/features/social/domain/entities/comet_user_entity.dart';
import 'package:uit_buddy_mobile/features/social/domain/entities/conversation_entity.dart';
import 'package:uit_buddy_mobile/features/social/domain/repositories/user_search_repository.dart';

class SearchCometUserUsecase
    implements UseCase<PagedResult<CometUserEntity>, SearchCometUserParams> {
  SearchCometUserUsecase({required UserSearchRepository repository})
    : _repository = repository;

  final UserSearchRepository _repository;

  @override
  Future<Either<Failure, PagedResult<CometUserEntity>>> call(
    SearchCometUserParams params,
  ) => _repository.searchCometUsers(
    query: params.query,
    page: params.page,
    limit: params.limit,
  );
}

class SearchCometUserParams extends Equatable {
  const SearchCometUserParams({
    required this.query,
    this.page = 1,
    this.limit = 10,
  });

  final String query;
  final int page;
  final int limit;

  @override
  List<Object?> get props => [query, page, limit];
}

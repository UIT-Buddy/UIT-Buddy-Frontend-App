import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';
import 'package:uit_buddy_mobile/core/common/paged_result.dart';
import 'package:uit_buddy_mobile/core/error/failures.dart';
import 'package:uit_buddy_mobile/core/usecase/usecase_interface.dart';
import 'package:uit_buddy_mobile/features/social/domain/entities/post_entity.dart';
import 'package:uit_buddy_mobile/features/social/domain/repositories/post_repository.dart';

class GetUserPostsUsecase
    implements UseCase<PagedResult<PostEntity>, GetUserPostsParams> {
  GetUserPostsUsecase({required PostRepository repository})
    : _repository = repository;

  final PostRepository _repository;

  @override
  Future<Either<Failure, PagedResult<PostEntity>>> call(
    GetUserPostsParams params,
  ) {
    return _repository.getPostsByUser(
      mssv: params.mssv,
      page: params.page,
      limit: params.limit,
    );
  }
}

class GetUserPostsParams extends Equatable {
  const GetUserPostsParams({
    required this.mssv,
    this.page = 1,
    this.limit = 10,
  });

  final String mssv;
  final int page;
  final int limit;

  @override
  List<Object?> get props => [mssv, page, limit];
}

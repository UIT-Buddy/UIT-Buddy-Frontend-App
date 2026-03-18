import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';
import 'package:uit_buddy_mobile/core/common/paged_result.dart';
import 'package:uit_buddy_mobile/core/error/failures.dart';
import 'package:uit_buddy_mobile/core/usecase/usecase_interface.dart';
import 'package:uit_buddy_mobile/features/social/domain/entities/post_entity.dart';
import 'package:uit_buddy_mobile/features/social/domain/repositories/post_repository.dart';

class GetNewfeedUsecase
    implements UseCase<PagedResult<PostEntity>, GetNewfeedParams> {
  GetNewfeedUsecase({required PostRepository repository})
      : _repository = repository;

  final PostRepository _repository;

  @override
  Future<Either<Failure, PagedResult<PostEntity>>> call(
    GetNewfeedParams params,
  ) => _repository.getPosts(cursor: params.cursor, limit: params.limit);
}

class GetNewfeedParams extends Equatable {
  final String? cursor;
  final int limit;

  const GetNewfeedParams({this.cursor, this.limit = 10});

  @override
  List<Object?> get props => [cursor, limit];
}

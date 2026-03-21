import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';
import 'package:uit_buddy_mobile/core/common/paged_result.dart';
import 'package:uit_buddy_mobile/core/error/failures.dart';
import 'package:uit_buddy_mobile/core/usecase/usecase_interface.dart';
import 'package:uit_buddy_mobile/features/social/domain/entities/comment_entity.dart';
import 'package:uit_buddy_mobile/features/social/domain/repositories/comment_repository.dart';

class GetPostCommentsUsecase
    implements UseCase<PagedResult<CommentEntity>, GetPostCommentsParams> {
  GetPostCommentsUsecase({required CommentRepository repository})
    : _repository = repository;

  final CommentRepository _repository;

  @override
  Future<Either<Failure, PagedResult<CommentEntity>>> call(
    GetPostCommentsParams params,
  ) => _repository.getPostComments(
    postId: params.postId,
    cursor: params.cursor,
    limit: params.limit,
  );
}

class GetPostCommentsParams extends Equatable {
  final String postId;
  final String? cursor;
  final int limit;

  const GetPostCommentsParams({
    required this.postId,
    this.cursor,
    this.limit = 10,
  });

  @override
  List<Object?> get props => [postId, cursor, limit];
}

import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';
import 'package:uit_buddy_mobile/core/common/paged_result.dart';
import 'package:uit_buddy_mobile/core/error/failures.dart';
import 'package:uit_buddy_mobile/core/usecase/usecase_interface.dart';
import 'package:uit_buddy_mobile/features/social/domain/entities/comment_entity.dart';
import 'package:uit_buddy_mobile/features/social/domain/repositories/comment_repository.dart';

class GetCommentRepliesUsecase
    implements UseCase<PagedResult<CommentEntity>, GetCommentRepliesParams> {
  GetCommentRepliesUsecase({required CommentRepository repository})
    : _repository = repository;

  final CommentRepository _repository;

  @override
  Future<Either<Failure, PagedResult<CommentEntity>>> call(
    GetCommentRepliesParams params,
  ) => _repository.getCommentReplies(
    commentId: params.commentId,
    cursor: params.cursor,
    limit: params.limit,
  );
}

class GetCommentRepliesParams extends Equatable {
  final String commentId;
  final String? cursor;
  final int limit;

  const GetCommentRepliesParams({
    required this.commentId,
    this.cursor,
    this.limit = 5,
  });

  @override
  List<Object?> get props => [commentId, cursor, limit];
}

import 'package:fpdart/fpdart.dart';
import 'package:uit_buddy_mobile/core/common/paged_result.dart';
import 'package:uit_buddy_mobile/core/error/failures.dart';
import 'package:uit_buddy_mobile/features/social/domain/entities/comment_entity.dart';

abstract interface class CommentRepository {
  Future<Either<Failure, PagedResult<CommentEntity>>> getPostComments({
    required String postId,
    String? cursor,
    int limit = 10,
  });

  Future<Either<Failure, Unit>> createComment({
    required String postId,
    required String content,
  });

  Future<Either<Failure, Unit>> replyToComment({
    required String commentId,
    required String content,
  });

  Future<Either<Failure, Unit>> updateComment({
    required String commentId,
    required String content,
  });

  Future<Either<Failure, PagedResult<CommentEntity>>> getCommentReplies({
    required String commentId,
    String? cursor,
    int limit = 5,
  });

  Future<Either<Failure, Unit>> deleteComment(String commentId);
}

import 'package:fpdart/fpdart.dart';
import 'package:uit_buddy_mobile/core/error/failures.dart';

abstract interface class ReactionRepository {
  Future<Either<Failure, Unit>> togglePostLike(String postId);

  Future<Either<Failure, Unit>> toggleCommentLike(String commentId);
}

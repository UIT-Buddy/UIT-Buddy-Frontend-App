import 'package:fpdart/fpdart.dart';
import 'package:uit_buddy_mobile/core/common/paged_result.dart';
import 'package:uit_buddy_mobile/core/error/failures.dart';
import 'package:uit_buddy_mobile/features/profile/domain/entities/post_entity.dart';

abstract interface class ProfilePostRepository {
  Future<Either<Failure, PagedResult<PostEntity>>> getPosts({
    String? cursor,
    int limit = 10,
  });

  Future<Either<Failure, Unit>> deletePost(String postId);

  Future<Either<Failure, Unit>> togglePostLike(String postId);
}

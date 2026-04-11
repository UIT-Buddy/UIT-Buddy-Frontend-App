import 'package:fpdart/fpdart.dart';
import 'package:uit_buddy_mobile/core/common/paged_result.dart';
import 'package:uit_buddy_mobile/core/error/failures.dart';
import 'package:uit_buddy_mobile/core/usecase/usecase_interface.dart';
import 'package:uit_buddy_mobile/features/profile/domain/entities/cursor_params.dart';
import 'package:uit_buddy_mobile/features/profile/domain/entities/post_entity.dart';
import 'package:uit_buddy_mobile/features/profile/domain/repositories/post_repository.dart';

class GetPostsUsecase
    implements UseCase<PagedResult<PostEntity>, CursorParams> {
  GetPostsUsecase({required ProfilePostRepository postRepository})
    : _postRepository = postRepository;

  final ProfilePostRepository _postRepository;
  @override
  Future<Either<Failure, PagedResult<PostEntity>>> call(
    CursorParams params,
  ) async =>
      _postRepository.getPosts(cursor: params.cursor, limit: params.limit);
}

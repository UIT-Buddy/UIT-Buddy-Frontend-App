import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';
import 'package:uit_buddy_mobile/core/common/paged_result.dart';
import 'package:uit_buddy_mobile/core/error/failures.dart';
import 'package:uit_buddy_mobile/core/usecase/usecase_interface.dart';
import 'package:uit_buddy_mobile/features/profile/domain/entities/post_entity.dart';
import 'package:uit_buddy_mobile/features/profile/domain/repositories/post_repository.dart';

class GetPostsUsecase implements UseCase<PagedResult<PostEntity>, GetPostsParams> {
  GetPostsUsecase({required ProfilePostRepository postRepository})
    : _postRepository = postRepository;

  final ProfilePostRepository _postRepository;
  @override
  Future<Either<Failure, PagedResult<PostEntity>>> call(GetPostsParams params) async =>
      _postRepository.getPosts(cursor: params.cursor, limit: params.limit);
}

class GetPostsParams extends Equatable {
  final String? cursor;
  final int limit;

  const GetPostsParams({this.cursor, this.limit = 10});

  @override
  List<Object?> get props => [cursor, limit];
}
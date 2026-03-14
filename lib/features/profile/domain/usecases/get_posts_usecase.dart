import 'package:fpdart/fpdart.dart';
import 'package:uit_buddy_mobile/core/error/failures.dart';
import 'package:uit_buddy_mobile/core/usecase/usecase_interface.dart';
import 'package:uit_buddy_mobile/features/profile/domain/entities/post_entity.dart';
import 'package:uit_buddy_mobile/features/profile/domain/repositories/post_repository.dart';

class GetPostsUsecase implements UseCase<List<PostEntity>, NoParams> {
  GetPostsUsecase({required PostRepository postRepository}) : _postRepository = postRepository;

  final PostRepository _postRepository;
  @override
  Future<Either<Failure, List<PostEntity>>> call(NoParams params) async =>
    _postRepository.getPosts();

}
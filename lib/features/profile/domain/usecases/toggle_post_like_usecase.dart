import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';
import 'package:uit_buddy_mobile/core/error/failures.dart';
import 'package:uit_buddy_mobile/core/usecase/usecase_interface.dart';
import 'package:uit_buddy_mobile/features/profile/domain/repositories/post_repository.dart';

class TogglePostLikeUsecase implements UseCase<Unit, TogglePostLikeParams> {
  TogglePostLikeUsecase({required ProfilePostRepository postRepository})
    : _postRepository = postRepository;

  final ProfilePostRepository _postRepository;

  @override
  Future<Either<Failure, Unit>> call(TogglePostLikeParams params) =>
      _postRepository.togglePostLike(params.postId);
}

class TogglePostLikeParams extends Equatable {
  final String postId;

  const TogglePostLikeParams({required this.postId});

  @override
  List<Object?> get props => [postId];
}

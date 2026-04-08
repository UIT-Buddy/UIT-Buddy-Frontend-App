import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';
import 'package:uit_buddy_mobile/core/error/failures.dart';
import 'package:uit_buddy_mobile/core/usecase/usecase_interface.dart';
import 'package:uit_buddy_mobile/features/profile/domain/repositories/post_repository.dart';

class DeleteYourPostUsecase implements UseCase<Unit, DeletePostParams> {
  DeleteYourPostUsecase({required ProfilePostRepository postRepository})
    : _postRepository = postRepository;

  final ProfilePostRepository _postRepository;

  @override
  Future<Either<Failure, Unit>> call(DeletePostParams params) =>
      _postRepository.deletePost(params.postId);
}

class DeletePostParams extends Equatable {
  final String postId;

  const DeletePostParams({required this.postId});

  @override
  List<Object?> get props => [postId];
}

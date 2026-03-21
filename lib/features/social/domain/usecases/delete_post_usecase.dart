import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';
import 'package:uit_buddy_mobile/core/error/failures.dart';
import 'package:uit_buddy_mobile/core/usecase/usecase_interface.dart';
import 'package:uit_buddy_mobile/features/social/domain/repositories/post_repository.dart';

class DeletePostUsecase implements UseCase<Unit, DeletePostParams> {
  DeletePostUsecase({required PostRepository repository})
    : _repository = repository;

  final PostRepository _repository;

  @override
  Future<Either<Failure, Unit>> call(DeletePostParams params) =>
      _repository.deletePost(params.postId);
}

class DeletePostParams extends Equatable {
  final String postId;

  const DeletePostParams({required this.postId});

  @override
  List<Object?> get props => [postId];
}

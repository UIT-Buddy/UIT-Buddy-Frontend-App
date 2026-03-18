import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';
import 'package:uit_buddy_mobile/core/error/failures.dart';
import 'package:uit_buddy_mobile/core/usecase/usecase_interface.dart';
import 'package:uit_buddy_mobile/features/social/domain/repositories/post_repository.dart';

class UpdatePostUsecase implements UseCase<Unit, UpdatePostParams> {
  UpdatePostUsecase({required PostRepository repository})
      : _repository = repository;

  final PostRepository _repository;

  @override
  Future<Either<Failure, Unit>> call(UpdatePostParams params) =>
      _repository.updatePost(
        postId: params.postId,
        title: params.title,
        content: params.content,
      );
}

class UpdatePostParams extends Equatable {
  final String postId;
  final String title;
  final String? content;

  const UpdatePostParams({
    required this.postId,
    required this.title,
    this.content,
  });

  @override
  List<Object?> get props => [postId, title, content];
}

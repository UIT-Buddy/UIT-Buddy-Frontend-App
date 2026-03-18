import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';
import 'package:uit_buddy_mobile/core/error/failures.dart';
import 'package:uit_buddy_mobile/core/usecase/usecase_interface.dart';
import 'package:uit_buddy_mobile/features/social/domain/repositories/comment_repository.dart';

class CreateCommentUsecase implements UseCase<Unit, CreateCommentParams> {
  CreateCommentUsecase({required CommentRepository repository})
      : _repository = repository;

  final CommentRepository _repository;

  @override
  Future<Either<Failure, Unit>> call(CreateCommentParams params) =>
      _repository.createComment(
        postId: params.postId,
        content: params.content,
      );
}

class CreateCommentParams extends Equatable {
  final String postId;
  final String content;

  const CreateCommentParams({required this.postId, required this.content});

  @override
  List<Object?> get props => [postId, content];
}

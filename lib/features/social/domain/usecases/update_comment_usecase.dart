import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';
import 'package:uit_buddy_mobile/core/error/failures.dart';
import 'package:uit_buddy_mobile/core/usecase/usecase_interface.dart';
import 'package:uit_buddy_mobile/features/social/domain/repositories/comment_repository.dart';

class UpdateCommentUsecase implements UseCase<Unit, UpdateCommentParams> {
  UpdateCommentUsecase({required CommentRepository repository})
    : _repository = repository;

  final CommentRepository _repository;

  @override
  Future<Either<Failure, Unit>> call(UpdateCommentParams params) => _repository
      .updateComment(commentId: params.commentId, content: params.content);
}

class UpdateCommentParams extends Equatable {
  final String commentId;
  final String content;

  const UpdateCommentParams({required this.commentId, required this.content});

  @override
  List<Object?> get props => [commentId, content];
}

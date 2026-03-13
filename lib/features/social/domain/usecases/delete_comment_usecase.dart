import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';
import 'package:uit_buddy_mobile/core/error/failures.dart';
import 'package:uit_buddy_mobile/core/usecase/usecase_interface.dart';
import 'package:uit_buddy_mobile/features/social/domain/repositories/social_repository.dart';

class DeleteCommentUsecase implements UseCase<Unit, DeleteCommentParams> {
  DeleteCommentUsecase({required SocialRepository repository})
    : _repository = repository;

  final SocialRepository _repository;

  @override
  Future<Either<Failure, Unit>> call(DeleteCommentParams params) =>
      _repository.deleteComment(params.commentId);
}

class DeleteCommentParams extends Equatable {
  final String commentId;

  const DeleteCommentParams({required this.commentId});

  @override
  List<Object?> get props => [commentId];
}

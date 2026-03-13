import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';
import 'package:uit_buddy_mobile/core/error/failures.dart';
import 'package:uit_buddy_mobile/core/usecase/usecase_interface.dart';
import 'package:uit_buddy_mobile/features/social/domain/repositories/social_repository.dart';

class ReplyToCommentUsecase implements UseCase<Unit, ReplyToCommentParams> {
  ReplyToCommentUsecase({required SocialRepository repository})
    : _repository = repository;

  final SocialRepository _repository;

  @override
  Future<Either<Failure, Unit>> call(ReplyToCommentParams params) =>
      _repository.replyToComment(
        commentId: params.commentId,
        content: params.content,
      );
}

class ReplyToCommentParams extends Equatable {
  final String commentId;
  final String content;

  const ReplyToCommentParams({
    required this.commentId,
    required this.content,
  });

  @override
  List<Object?> get props => [commentId, content];
}

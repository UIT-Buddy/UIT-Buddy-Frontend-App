import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';
import 'package:uit_buddy_mobile/core/error/failures.dart';
import 'package:uit_buddy_mobile/core/usecase/usecase_interface.dart';
import 'package:uit_buddy_mobile/features/social/domain/repositories/reaction_repository.dart';

class ToggleCommentLikeUsecase
    implements UseCase<Unit, ToggleCommentLikeParams> {
  ToggleCommentLikeUsecase({required ReactionRepository repository})
      : _repository = repository;

  final ReactionRepository _repository;

  @override
  Future<Either<Failure, Unit>> call(ToggleCommentLikeParams params) =>
      _repository.toggleCommentLike(params.commentId);
}

class ToggleCommentLikeParams extends Equatable {
  final String commentId;

  const ToggleCommentLikeParams({required this.commentId});

  @override
  List<Object?> get props => [commentId];
}
